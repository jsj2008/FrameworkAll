//
//  XMLSprite.m
//  FoundationProject
//
//  Created by user on 13-11-29.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "XMLSprite.h"

#pragma mark - XMLSprite

@implementation XMLSprite

@end


#pragma mark - XMLDocumentSprite

@implementation XMLDocumentSprite

- (id)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        xmlDocPtr doc = xmlReadMemory([data bytes], (int)[data length], NULL, NULL, XML_PARSE_NOERROR | XML_PARSE_NOWARNING | XML_PARSE_NOBLANKS | XML_PARSE_RECOVER);
        
        if (doc->version)
        {
            self.XMLVersion = [NSString stringWithUTF8String:(const char *)doc->version];
        }
        
        xmlNodePtr rootXMLNode = xmlDocGetRootElement(doc);
        
        if (rootXMLNode)
        {
            self.rootNode = [[XMLNodeSprite alloc] initWithLibXMLNode:rootXMLNode];
        }
        
        xmlFreeDoc(doc);
    }
    
    return self;
}

- (id)initWithFile:(NSString *)filePath
{
    if (self = [super init])
    {
        xmlDocPtr doc = xmlReadFile([filePath UTF8String], NULL, XML_PARSE_NOERROR | XML_PARSE_NOWARNING | XML_PARSE_NOBLANKS | XML_PARSE_RECOVER);
        
        if (doc->version)
        {
            self.XMLVersion = [NSString stringWithUTF8String:(const char *)doc->version];
        }
        
        xmlNodePtr rootXMLNode = xmlDocGetRootElement(doc);
        
        if (rootXMLNode)
        {
            self.rootNode = [[XMLNodeSprite alloc] initWithLibXMLNode:rootXMLNode];
        }
        
        xmlFreeDoc(doc);
    }
    
    return self;
}

- (NSData *)serializedDataUsingEncoding:(NSString *)encoding
{
    xmlDocPtr doc = xmlNewDoc((const xmlChar *)[self.XMLVersion UTF8String]);
    
    xmlNodePtr rootXMLNode = [self.rootNode createLibXMLNode];
    
    xmlDocSetRootElement(doc, rootXMLNode);
    
    xmlChar *bytes;
    
    int length = 0;
    
    xmlDocDumpMemoryEnc(doc, &bytes, &length, encoding ? [encoding UTF8String] : "utf-8");
    
    NSData *data = nil;
    
    if (bytes && length)
    {
        data = [NSData dataWithBytes:bytes length:length];
    }
    
    xmlFreeDoc(doc);
    
    return data;
}

- (BOOL)saveToFile:(NSString *)filePath usingEncoding:(NSString *)encoding
{
    xmlDocPtr doc = xmlNewDoc((const xmlChar *)[self.XMLVersion UTF8String]);
    
    xmlNodePtr rootXMLNode = [self.rootNode createLibXMLNode];
    
    xmlDocSetRootElement(doc, rootXMLNode);
    
    // xmlSaveFileEnc, return the number of bytes written or -1 in case of failure
    BOOL success = (xmlSaveFileEnc([filePath UTF8String], doc, encoding ? [encoding UTF8String] : "utf-8") >= 0);
    
    xmlFreeDoc(doc);
    
    return success;
}

- (id)jsonNode
{
    return [self.rootNode jsonNode];
}

- (id)initWithJsonNode:(id)jsonNode
{
    if (self = [super init])
    {
        self.XMLVersion = @"1.0";
        
        self.rootNode = [[XMLNodeSprite alloc] initWithJsonNode:jsonNode];
        
        self.rootNode.nodeName = @"root";
    }
    
    return self;
}

@end


#pragma mark - XMLNodeSprite

@interface XMLNodeSprite ()

/*!
 * @brief 节点内容
 */
@property (nonatomic, retain) XMLContentSprite *nodeContent;

@end


@implementation XMLNodeSprite

- (id)init
{
    if (self = [super init])
    {
        _properties = [[NSMutableDictionary alloc] init];
        
        _childNodes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (xmlNodePtr)createLibXMLNode
{
    xmlNodePtr node = xmlNewNode(NULL, BAD_CAST([self.nodeName UTF8String]));
    
    for (NSString *propertyName in [_properties allKeys])
    {
        NSString *propertyValue = [_properties objectForKey:propertyName];
        
        xmlSetProp(node, BAD_CAST([propertyName UTF8String]), BAD_CAST([propertyValue UTF8String]));
    }
    
    if ([_childNodes count])
    {
        for (XMLNodeSprite *nodeSprite in _childNodes)
        {
            xmlNodePtr childNode = [nodeSprite createLibXMLNode];
            
            xmlAddChild(node, childNode);
        }
    }
    
    if (self.nodeContent)
    {
        if ([self.content isKindOfClass:[XMLTextContentSprite class]])
        {
            xmlNodeSetContent(node, BAD_CAST([[self.nodeContent content] UTF8String]));
        }
        else if ([self.content isKindOfClass:[XMLCDataContentSprite class]])
        {
            const char *string = [[self.nodeContent content] UTF8String];
            
            xmlNodePtr cdata = xmlNewCDataBlock(NULL, BAD_CAST(string), (int)strlen(string));
            
            xmlAddChild(node, cdata);
        }
    }
    
    return node;
}

- (id)initWithLibXMLNode:(xmlNodePtr)node
{
    if (self = [super init])
    {
        _properties = [[NSMutableDictionary alloc] init];
        
        _childNodes = [[NSMutableArray alloc] init];
        
        if (node->name)
        {
            self.nodeName = [NSString stringWithUTF8String:(const char *)node->name];
        }
        
        xmlAttrPtr attribute = node->properties;
        
        while (attribute)
        {
            const xmlChar *propertyNameChar = attribute->name;
            
            const xmlChar *propertyValueChar = attribute->children->content;
            
            if (propertyNameChar && propertyValueChar)
            {
                [_properties setObject:[NSString stringWithUTF8String:(const char *)propertyValueChar] forKey:[NSString stringWithUTF8String:(const char *)propertyNameChar]];
            }
            
            attribute = attribute->next;
        }
        
        xmlNodePtr childNode = node->children;
        
        while (childNode)
        {
            if (childNode->type == XML_ELEMENT_NODE)
            {
                XMLNodeSprite *nodeSprite = [[XMLNodeSprite alloc] initWithLibXMLNode:childNode];
                
                nodeSprite.parentNode = self;
                
                [_childNodes addObject:nodeSprite];
            }
            else if (childNode->type == XML_TEXT_NODE && childNode->content)
            {
                XMLTextContentSprite *contentSprite = [[XMLTextContentSprite alloc] init];
                
                contentSprite.content = [NSString stringWithUTF8String:(const char *)childNode->content];
                
                self.nodeContent = contentSprite;
            }
            else if (childNode->type == XML_CDATA_SECTION_NODE && childNode->content)
            {
                XMLCDataContentSprite *contentSprite = [[XMLCDataContentSprite alloc] init];
                
                contentSprite.content = [NSString stringWithUTF8String:(const char *)childNode->content];
                
                self.nodeContent = contentSprite;
            }
            
            childNode = childNode->next;
        }
    }
    
    return self;
}

- (id)jsonNode
{
    id node = nil;
    
    if (self.nodeContent)
    {
        node = [self.nodeContent.content copy];
    }
    else if ([_childNodes count])
    {
        NSMutableDictionary *jsonNode = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *nameRecords = [NSMutableDictionary dictionary];
        
        for (XMLNodeSprite *childNode in _childNodes)
        {
            if ([[nameRecords allKeys] containsObject:childNode.nodeName])
            {
                NSMutableArray *values = [nameRecords objectForKey:childNode.nodeName];
                
                [values addObject:childNode];
            }
            else if (childNode.nodeName)
            {
                NSMutableArray *values = [NSMutableArray arrayWithObject:childNode];
                
                [nameRecords setObject:values forKey:childNode.nodeName];
            }
        }
        
        for (NSMutableArray *values in [nameRecords allValues])
        {
            NSString *name = nil;
            
            NSMutableArray *jsonValues = [NSMutableArray array];
            
            for (XMLNodeSprite *node in values)
            {
                id jsonValue = [node jsonNode];
                
                if (jsonValue && node.nodeName)
                {
                    [jsonValues addObject:jsonValue];
                    
                    name = node.nodeName;
                }
            }
            
            if (name && [jsonValues count] == 1)
            {
                [jsonNode setObject:[jsonValues objectAtIndex:0] forKey:name];
            }
            else if (name && [jsonValues count] > 1)
            {
                [jsonNode setObject:jsonValues forKey:name];
            }
        }
        
        [jsonNode addEntriesFromDictionary:_properties];
        
        node = [jsonNode count] ? jsonNode : nil;
    }
    
    return node;
}

- (id)initWithJsonNode:(id)jsonNode
{
    if (self = [super init])
    {
        _properties = [[NSMutableDictionary alloc] init];
        
        _childNodes = [[NSMutableArray alloc] init];
        
        if ([jsonNode isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *node = (NSDictionary *)jsonNode;
            
            for (NSString *key in [node allKeys])
            {
                id value = [node objectForKey:key];
                
                if ([value isKindOfClass:[NSArray class]])
                {
                    for (id object in (NSArray *)value)
                    {
                        XMLNodeSprite *childNode = [[XMLNodeSprite alloc] initWithJsonNode:object];
                        
                        childNode.nodeName = key;
                        
                        childNode.parentNode = self;
                        
                        [_childNodes addObject:childNode];
                    }
                }
                else
                {
                    XMLNodeSprite *childNode = [[XMLNodeSprite alloc] initWithJsonNode:value];
                    
                    childNode.nodeName = key;
                    
                    childNode.parentNode = self;
                    
                    [_childNodes addObject:childNode];
                }
            }
        }
        else if ([jsonNode isKindOfClass:[NSString class]])
        {
            [self setTextContent:jsonNode];
        }
        else if ([jsonNode isKindOfClass:[NSNumber class]])
        {
            [self setTextContent:[jsonNode description]];
        }
    }
    
    return self;
}

- (XMLNodeSprite *)copyWithList:(BOOL)withList
{
    XMLNodeSprite *node = [[XMLNodeSprite alloc] init];
    
    node.nodeName = self.nodeName;
    
    [node setAttributesDictionary:_properties];
    
    if (withList)
    {
        if ([_childNodes count])
        {
            NSMutableArray *newChildNodes = [NSMutableArray array];
            
            for (XMLNodeSprite *childNode in _childNodes)
            {
                XMLNodeSprite *newChildNode = [childNode copyWithList:withList];
                
                newChildNode.parentNode = node;
                
                [newChildNodes addObject:newChildNode];
            }
            
            [node addChildNodes:newChildNodes];
        }
        
        [node setContent:self.nodeContent];
    }
    
    return node;
}

- (XMLNodeSprite *)previousNode
{
    NSInteger selfIndex = [self.parentNode indexOfChildNode:self];
    
    return [self.parentNode childNodeAtIndex:(selfIndex - 1)];
}

- (XMLNodeSprite *)nextNode
{
    NSInteger selfIndex = [self.parentNode indexOfChildNode:self];
    
    return [self.parentNode childNodeAtIndex:(selfIndex + 1)];
}

- (XMLNodeSprite *)childNodeAtIndex:(NSUInteger)index
{
    XMLNodeSprite *node = nil;
    
    if (index < [_childNodes count])
    {
        node = [_childNodes objectAtIndex:index];
    }
    
    return node;
}

- (NSInteger)indexOfChildNode:(XMLNodeSprite *)node
{
    NSUInteger index = [_childNodes indexOfObject:node];
    
    return (index >= [_childNodes count]) ? -1 : index;
}

- (NSArray *)allChildNodes
{
    return [_childNodes count] ? [NSArray arrayWithArray:_childNodes] : nil;
}

- (NSArray *)allChildNodesNamed:(NSString *)name
{
    if (!name)
    {
        return nil;
    }
    
    NSMutableArray *childNodes = [NSMutableArray array];
    
    for (XMLNodeSprite *node in _childNodes)
    {
        if ([node.nodeName isEqualToString:name])
        {
            [childNodes addObject:node];
        }
    }
    
    return [childNodes count] ? childNodes : nil;
}

- (XMLNodeSprite *)firstChildNodeNamed:(NSString *)name
{
    if (!name)
    {
        return nil;
    }
    
    XMLNodeSprite *childNode = nil;
    
    for (XMLNodeSprite *node in _childNodes)
    {
        if ([node.nodeName isEqualToString:name])
        {
            childNode = node;
            
            break;
        }
    }
    
    return childNode;
}

- (XMLNodeSprite *)lastChildNodeNamed:(NSString *)name
{
    if (!name)
    {
        return nil;
    }
    
    XMLNodeSprite *childNode = nil;
    
    if ([_childNodes count])
    {
        for (NSUInteger i = [_childNodes count]; i > 0; i --)
        {
            XMLNodeSprite *node = [_childNodes objectAtIndex:(i - 1)];
            
            if ([node.nodeName isEqualToString:name])
            {
                childNode = node;
                
                break;
            }
        }
    }
    
    return childNode;
}

- (void)addChildNodes:(NSArray *)childNodes
{
    self.nodeContent = nil;
    
    if ([childNodes count])
    {
        [_childNodes addObjectsFromArray:childNodes];
        
        for (XMLNodeSprite *childNode in childNodes)
        {
            childNode.parentNode = self;
        }
    }
}

- (void)addChildNode:(XMLNodeSprite *)childNode atIndex:(NSUInteger)index
{
    self.nodeContent = nil;
    
    if (!childNode)
    {
        return;
    }
    
    if (index < [_childNodes count])
    {
        [_childNodes insertObject:childNode atIndex:index];
    }
    else
    {
        [_childNodes addObject:childNode];
    }
    
    childNode.parentNode = self;
}

- (void)removeChildNodes:(NSArray *)childNodes
{
    for (XMLNodeSprite *childNode in childNodes)
    {
        if ([_childNodes containsObject:childNode])
        {
            childNode.parentNode = nil;
        }
    }
    
    [_childNodes removeObjectsInArray:childNodes];
}

- (void)replaceChildNodeAtIndex:(NSUInteger)index byNewNode:(XMLNodeSprite *)newNode
{
    if (newNode && (index < [_childNodes count]) && ([_childNodes objectAtIndex:index] != newNode))
    {
        ((XMLNodeSprite *)[_childNodes objectAtIndex:index]).parentNode = nil;
        
        [_childNodes replaceObjectAtIndex:index withObject:newNode];
    }
}

- (NSString *)valueOfAttributeNamed:(NSString *)name
{
    return name ? [_properties objectForKey:name] : nil;
}

- (void)setValue:(NSString *)value ofAttributeNamed:(NSString *)name
{
    if (name && value)
    {
        [_properties setObject:value forKey:name];
    }
}

- (void)setAttributesDictionary:(NSDictionary *)attributes
{
    if ([attributes count])
    {
        [_properties addEntriesFromDictionary:attributes];
    }
}

- (BOOL)hasAttributeNamed:(NSString *)name
{
    return name ? [[_properties allKeys] containsObject:name] : NO;
}

- (void)removeAttributeNamed:(NSString *)name
{
    if (name)
    {
        [_properties removeObjectForKey:name];
    }
}

- (XMLContentSprite *)content
{
    return self.nodeContent;
}

- (void)setContent:(XMLContentSprite *)content
{
    self.nodeContent = content;
}

- (void)removeContent
{
    self.nodeContent = nil;
}

@end


@implementation XMLNodeSprite (Shortcut)

- (void)setTextContent:(NSString *)content
{
    XMLTextContentSprite *contentSprite = [[XMLTextContentSprite alloc] init];
    
    contentSprite.content = content;
    
    self.nodeContent = contentSprite;
}

@end


#pragma mark - XMLContentSprite

@implementation XMLContentSprite

@end


@implementation XMLTextContentSprite

@end


@implementation XMLCDataContentSprite

@end


#pragma mark - XMLNodeSpriteSearchContext

@implementation XMLNodeSpriteSearchContext

@end


#pragma mark - XMLDocumentSprite (Search)

@implementation XMLDocumentSprite (Search)

- (NSArray *)subNodesSearchedWithContext:(XMLNodeSpriteSearchContext *)context
{
    return [self.rootNode subNodesSearchedWithContext:context includingSelfNode:YES];
}

@end


#pragma mark - XMLNodeSprite (Search)

@implementation XMLNodeSprite (Search)

- (NSArray *)subNodesSearchedWithContext:(XMLNodeSpriteSearchContext *)context includingSelfNode:(BOOL)including
{
    NSMutableArray *subNodes = [NSMutableArray array];
    
    NSMutableArray *candidateNodes = [NSMutableArray array];
    
    if ([_childNodes count])
    {
        [candidateNodes addObjectsFromArray:_childNodes];
    }
    
    if (including)
    {
        [candidateNodes addObject:self];
    }
    
    for (XMLNodeSprite *candidateNode in candidateNodes)
    {
        BOOL searched = YES;
        
        if (searched && context.nodeName && ![context.nodeName isEqualToString:candidateNode.nodeName])
        {
            searched = NO;
        }
        
        if (searched && [context.nodeProperties count])
        {
            for (NSString *key in context.nodeProperties)
            {
                if (!([candidateNode hasAttributeNamed:key] && [[context.nodeProperties objectForKey:key] isEqualToString:[candidateNode valueOfAttributeNamed:key]]))
                {
                    searched = NO;
                    
                    break;
                }
            }
        }
        
        if (searched && context.nodeContent && ![context.nodeContent isEqualToString:[candidateNode content].content])
        {
            searched = NO;
        }
        
        if (searched)
        {
            [subNodes addObject:candidateNode];
        }
        
        if (candidateNode != self)
        {
            NSArray *subNodesOfChildNode = [candidateNode subNodesSearchedWithContext:context includingSelfNode:NO];
            
            if ([subNodesOfChildNode count])
            {
                [subNodes addObjectsFromArray:subNodesOfChildNode];
            }
        }
    }
    
    return [subNodes count] ? subNodes : nil;
}

@end
