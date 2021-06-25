//
//
//  HCCircularQueue.h
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/26.
//  
//
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCCircularQueue<__covariant T> : NSObject

@property(nonatomic, assign, readonly) NSUInteger count;
@property(nonatomic, assign, readonly) BOOL isEmpty;

- (void)removeAllNodes;
- (void)resize:(NSUInteger)capacity;
- (void)addNode:(T)obj;
- (void)addNodeToFront:(T)obj;
- (T)removeFirstNode;
- (T)nodeAtIndex:(NSUInteger)index;
- (T)firstNode;
- (T)lastNode;

- (void)enumerateObjectsUsingBlock:(void (^)(T obj, NSUInteger index, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
