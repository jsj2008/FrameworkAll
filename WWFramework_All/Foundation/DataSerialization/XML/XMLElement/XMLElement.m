//
//  XMLElement.m
//  FoundationProject
//
//  Created by user on 13-11-26.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "XMLElement.h"
#import "XMLUtility.h"
#import "APPDebug.h"

#pragma mark - XMLElement

@implementation XMLElement

- (void)coreRetain
{
    _coreRetainCount ++;
}

- (void)coreRelease
{
    _coreRetainCount --;
    
    [APPDebug assertWithCondition:(_coreRetainCount >= 0) string:@"object of XMLElement class or its subclass being freed was not be allocated"];
}

@end


#pragma mark - XMLDocumentElement

@implementation XMLDocumentElement

@synthesize doc = _doc;

- (id)initWithXMLDoc:(xmlDocPtr)doc
{
    if (self = [super init])
    {
        _doc = doc;
    }
    
    return self;
}

- (id)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        _doc = xmlReadMemory([data bytes], (int)[data length], NULL, NULL, XML_PARSE_NOERROR | XML_PARSE_NOWARNING | XML_PARSE_NOBLANKS | XML_PARSE_RECOVER);
        
        _coreRetainCount = 1;
    }
    
    return self;
}

- (id)initWithFile:(NSString *)filePath
{
    if (self = [super init])
    {
        _doc = xmlReadFile([filePath UTF8String], NULL, XML_PARSE_NOERROR | XML_PARSE_NOWARNING | XML_PARSE_NOBLANKS | XML_PARSE_RECOVER);
        
        _coreRetainCount = 1;
    }
    
    return self;
}

- (void)dealloc
{
    if (_doc && _coreRetainCount)
    {
        xmlFreeDoc(_doc);
    }
}

- (NSData *)serializedDataUsingEncoding:(NSString *)encoding
{
    xmlChar *bytes;
    
    int length = 0;
    
    xmlDocDumpMemoryEnc(_doc, &bytes, &length, encoding ? [encoding UTF8String] : "utf-8");
    
    NSData *data = nil;
    
    if (bytes && length)
    {
        data = [NSData dataWithBytes:bytes length:length];
    }
    
    return data;
}

- (BOOL)saveToFile:(NSString *)filePath usingEncoding:(NSString *)encoding
{
    // xmlSaveFileEnc, return the number of bytes written or -1 in case of failure
    return (xmlSaveFileEnc([filePath UTF8String], _doc, encoding ? [encoding UTF8String] : "utf-8") >= 0);
}

- (XMLNodeElement *)rootNode
{
    xmlNodePtr node = xmlDocGetRootElement(_doc);
    
    return node ? [[XMLNodeElement alloc] initWithXMLNode:node] : nil;
}

- (NSString *)stringEncoding
{
    return [NSString stringWithXMLChar:_doc->encoding withStringEncoding:NSUTF8StringEncoding];
}

- (BOOL)isDocumentValid
{
    return _doc ? YES : NO;
}

@end


#pragma mark - XMLNodeElement

@implementation XMLNodeElement

@synthesize node = _node;

- (id)init
{
    if (self = [super init])
    {
        _encoding = NSUTF8StringEncoding;
    }
    
    return self;
}

- (id)initWithXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        _node = node;
        
        _encoding = NSUTF8StringEncoding;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name
{
    if (self = [super init])
    {
        _node = xmlNewNode(NULL, BAD_CAST([name UTF8String]));
        
        _encoding = NSUTF8StringEncoding;
        
        _coreRetainCount = 1;
    }
    
    return self;
}

- (void)dealloc
{
    if (_node && _coreRetainCount)
    {
        xmlFreeNode(_node);
    }
}

- (XMLNodeElement *)copyWithList:(BOOL)withList
{
    // xmlCopyNode (const xmlNodePtr node, int recursive); recursive, if 1 do a recursive copy (properties, namespaces and children when applicable) if 2 copy properties and namespaces (when applicable)
    xmlNodePtr node = xmlCopyNode(_node, withList ? 1 : 2);
    
    XMLNodeElement *newNode = node ? [[XMLNodeElement alloc] initWithXMLNode:node] : nil;
    
    [newNode coreRetain];
    
    return newNode;
}

- (XMLNodeElement *)previousNode
{
    xmlNodePtr node = _node->prev;
    
    return node ? [[XMLNodeElement alloc] initWithXMLNode:node] : nil;
}

- (XMLNodeElement *)nextNode
{
    xmlNodePtr node = _node->next;
    
    return node ? [[XMLNodeElement alloc] initWithXMLNode:node] : nil;
}

- (XMLNodeElement *)firstChildNode
{
    xmlNodePtr node = _node->children;
    
    return node ? [[XMLNodeElement alloc] initWithXMLNode:node] : nil;
}

- (NSArray *)childNodesNamed:(NSString *)name
{
    NSMutableArray *childNodes = [NSMutableArray array];
    
    xmlChar *xmlName = BAD_CAST([name UTF8String]);
    
    xmlNodePtr childNode = _node->children;
    
    while (childNode)
    {
        if (!xmlStrcmp(childNode->name, xmlName))
        {
            XMLNodeElement *node = [[XMLNodeElement alloc] initWithXMLNode:childNode];
            
            [childNodes addObject:node];
        }
        
        childNode = childNode->next;
    }
    
    return [childNodes count] ? childNodes : nil;
}

- (void)addPreviousNode:(XMLNodeElement *)node
{
    xmlAddPrevSibling(_node, node.node);
    
    [node coreRelease];
}

- (void)addNextNode:(XMLNodeElement *)node
{
    xmlAddNextSibling(_node, node.node);
    
    [node coreRelease];
}

- (void)addChildNodes:(NSArray *)childNodes
{
    for (XMLNodeElement *childNode in childNodes)
    {
        if (childNode.node)
        {
            xmlAddChild(_node, childNode.node);
            
            [childNode coreRelease];
        }
    }
}

- (XMLNodeElement *)addChildNodeWithName:(NSString *)name content:(NSString *)content
{
    xmlNodePtr node = xmlNewChild(_node, NULL, BAD_CAST([name UTF8String]), BAD_CAST([content UTF8String]));
    
    return node ? [[XMLNodeElement alloc] initWithXMLNode:node] : nil;
}

- (void)unlinkFromDoc
{
    xmlUnlinkNode(_node);
    
    _coreRetainCount ++;
}

- (void)replaceByNode:(XMLNodeElement *)node
{
    if (_node != node.node)
    {
        xmlReplaceNode(_node, node.node);
        
        _coreRetainCount ++;
    }
}

- (NSString *)name
{
    return _node->name ? [NSString stringWithXMLChar:BAD_CAST(_node->name) withStringEncoding:_encoding] : nil;
}

- (NSString *)encoding
{
    return _node->doc->encoding ? [NSString stringWithXMLChar:BAD_CAST(_node->doc->encoding) withStringEncoding:_encoding] : nil;
}

- (NSString *)valueOfAttributeNamed:(NSString *)name
{
    NSString *value = nil;
    
    if ([name length])
    {
        xmlChar *attribute = xmlGetProp(_node, BAD_CAST([name UTF8String]));
        
        if (attribute)
        {
            value = [NSString stringWithXMLChar:attribute withStringEncoding:_encoding];
        }
        
        xmlFree(attribute);
    }
    
    return value;
}

- (void)setValue:(NSString *)value ofAttributeNamed:(NSString *)name
{
    if (name && value)
    {
        xmlSetProp(_node, BAD_CAST([name cStringUsingEncoding:_encoding]), BAD_CAST([value cStringUsingEncoding:_encoding]));
    }
}

- (BOOL)hasAttributeNamed:(NSString *)name
{
    BOOL has = NO;
    
    if (name)
    {
        has = xmlHasProp(_node, BAD_CAST([name cStringUsingEncoding:_encoding])) ? YES : NO;
    }
    
    return has;
}

- (void)removeAttributeNamed:(NSString *)name
{
    xmlUnsetProp(_node, BAD_CAST([name UTF8String]));
}

- (NSString *)content
{
    NSString *content = nil;
    
    xmlChar *text = NULL;
    
    // 这里不要使用xmlNodeGetContent(xmlNodePtr cur)来获取content，此方法会将所有子孙节点的文本做字符串拼接
    
    if (_node->type == XML_TEXT_NODE)
    {
        text = _node->content;
    }
    else if (_node->type == XML_ELEMENT_NODE && _node->children->type == XML_TEXT_NODE)
    {
        text = _node->children->content;
    }
    
    if (text)
    {
        content = [NSString stringWithXMLChar:text withStringEncoding:_encoding];
    }
    
    return content;
}

- (void)setContent:(NSString *)content
{
    if (content)
    {
        xmlNodeSetContent(_node, BAD_CAST([content cStringUsingEncoding:_encoding]));
    }
}

- (void)removeContent
{
    xmlNodeSetContent(_node, NULL);
}

@end


#pragma mark - XMLXPathElement

@implementation XMLXPathElement

@synthesize result = _result;

- (id)initWithDocument:(xmlDocPtr)doc expression:(NSString *)expression
{
    if (self = [super init])
    {
        xmlXPathContextPtr context = xmlXPathNewContext(doc);
        
        _result = xmlXPathEvalExpression((xmlChar *)[expression UTF8String], context);
        
        xmlXPathFreeContext(context);
        
        if (_result && xmlXPathNodeSetIsEmpty(_result->nodesetval))
        {
            xmlXPathFreeObject(_result);
            
            _result = NULL;
        }
        
        _coreRetainCount = 1;
    }
    
    return self;
}

- (void)dealloc
{
    if (_result && _coreRetainCount)
    {
        xmlXPathFreeObject(_result);
    }
}

- (NSArray *)resultNodes
{
    if (_result)
    {
        NSMutableArray *nodes = [NSMutableArray array];
        
        xmlNodeSetPtr nodeSet = _result->nodesetval;
        
        for (int i = 0; i < nodeSet->nodeNr; i ++)
        {
            xmlNodePtr node = nodeSet->nodeTab[i];
            
            [nodes addObject:[[XMLNodeElement alloc] initWithXMLNode:node]];
        }
        
        return nodes;
    }
    else
    {
        return nil;
    }
}

@end
