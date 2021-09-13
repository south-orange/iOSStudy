//
//
//  HCLinkList.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/27.
//  
//
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCLinkNode : NSObject

@property(nonatomic, weak, nullable) HCLinkNode *prev;
@property(nonatomic, strong, nullable) HCLinkNode *next;

@property(nonatomic, strong) NSObject *value;

+ (instancetype)nodeWithValue:(id)value;

@end

@interface HCLinkList : NSObject

@property(nonatomic, assign, readonly) NSUInteger nodeCount;

- (HCLinkNode *)headNode;
- (void)addNode:(HCLinkNode *)node;
- (void)addNodeToFront:(HCLinkNode *)node;
- (HCLinkNode *)removeNode:(HCLinkNode *)node;// 返回删除节点的下一个节点
- (void)removeAllNodes;
- (void)removeAllNodesAfterNode:(HCLinkNode *)node;// 删除某一节点之后的所有节点

- (void)enumerateObjectsUsingBlock:(void (^)(HCLinkNode *obj, NSUInteger index, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
