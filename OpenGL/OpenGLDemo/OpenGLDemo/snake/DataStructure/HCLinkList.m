//
//
//  HCLinkList.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/27.
//  
//
    

#import "HCLinkList.h"

@implementation HCLinkNode

+ (instancetype)nodeWithValue:(id)value {
    HCLinkNode *node = [self new];
    node.value = value;
    return node;
}

@end

@interface HCLinkList ()

@property(nonatomic, strong) HCLinkNode *head;
@property(nonatomic, strong) HCLinkNode *tail;
@property(nonatomic, assign) NSUInteger nodeCount;

@end

@implementation HCLinkList

- (void)dealloc
{
    [self removeAllNodes];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.head = HCLinkNode.new;
        self.tail = HCLinkNode.new;
        self.head.next = self.tail;
        self.tail.prev = self.head;
        self.nodeCount = 0;
    }
    return self;
}

- (HCLinkNode *)headNode {
    return self.head.next;
}

- (void)addNode:(HCLinkNode *)node {
    if (node == nil) {
        return;
    }
    HCLinkNode *oldPreTailNode = self.tail.prev;
    HCLinkNode *tailNode = self.tail;
    
    node.prev = oldPreTailNode;
    node.next = tailNode;
    
    oldPreTailNode.next = node;
    
    tailNode.prev = node;
    
    self.nodeCount ++;
}

- (void)addNodeToFront:(HCLinkNode *)node {
    if (node == nil) {
        return;
    }
    HCLinkNode *oldFrontHeadNode = self.head.next;
    
    node.prev = self.head;
    node.next = oldFrontHeadNode;
    
    oldFrontHeadNode.prev = node;
    
    self.head.next = node;
    
    self.nodeCount ++;
}

- (HCLinkNode *)removeNode:(HCLinkNode *)node {
    if (node == nil) {
        return nil;
    }
    
    HCLinkNode *prev = node.prev;
    HCLinkNode *next = node.next;
    if (prev == nil || next == nil) {
        return nil;
    }
    
    prev.next = next;
    next.prev = prev;
    
    node.prev = nil;
    node.next = nil;
    
    self.nodeCount --;
    
    return next;
}

- (void)removeAllNodes {
    HCLinkNode *node = self.tail;
    while (node.prev) {
        node = node.prev;
        node.next = nil;
    }
    self.head.next = self.tail;
    self.tail.prev = self.head;
    self.nodeCount = 0;
}

- (void)enumerateObjectsUsingBlock:(void (^)(HCLinkNode * _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    BOOL stop = NO;
    NSUInteger index = 0;
    HCLinkNode *node = self.head.next;
    while (node != self.tail) {
        block(node, index, &stop);
        if (stop) {
            break;
        }
        node = node.next;
        index ++;
    }
}

@end
