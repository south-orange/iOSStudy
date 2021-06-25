//
//
//  HCCircularQueue.m
//  OpenGLDemo
//
//  Created by 霍橙 on 2021/5/26.
//  
//
    

#import "HCCircularQueue.h"

#define HCCircleQueueInitSize 16

@interface HCCircularQueue<__covariant T> ()

@property(nonatomic, strong) NSMutableArray<T> *objArray;

@property(nonatomic, assign) NSUInteger front;
@property(nonatomic, assign) NSUInteger rear;

@property(nonatomic, assign) NSUInteger count;
@property(nonatomic, assign) NSUInteger capacity;

@end

@implementation HCCircularQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.capacity = HCCircleQueueInitSize;
        self.objArray = [NSMutableArray arrayWithCapacity:self.capacity];
        self.front = 0;
        self.rear = 0;
        self.count = 0;
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    self = [super init];
    if (self) {
        [self resize:capacity];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc %@", self);
}

- (void)removeAllNodes {
    [self.objArray removeAllObjects];
    self.front = 0;
    self.rear = 0;
    self.count = 0;
}

- (void)resize:(NSUInteger)capacity {
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:capacity];
    for (NSUInteger i = 0;i < capacity;i ++) {
        id obj = [self nodeAtIndex:i];
        if (obj == nil) {
            obj = NSObject.new;
        }
        [newArray addObject:obj];
    }
    self.objArray = newArray;
    self.front = 0;
    self.rear = self.count;
    self.capacity = capacity;
}

- (void)addNode:(id)obj {
    if (!obj) {
        NSLog(@"object is nil");
        return;
    }
    if (self.count == _capacity) {
        [self resize:self.capacity * 2];
    }
    
    self.objArray[self.rear] = obj;
    self.rear = (self.rear + 1) % self.capacity;
    self.count ++;
}

- (void)addNodeToFront:(id)obj {
    if (!obj) {
        NSLog(@"object is nil");
        return;
    }
    if (self.count == _capacity) {
        [self resize:self.capacity * 2];
    }
    
    self.front = (self.front - 1) % self.capacity;
    self.objArray[self.front] = obj;
    self.count ++;
}

- (id)removeFirstNode {
    if (self.isEmpty) {
        NSLog(@"queue is empty");
        return nil;
    }
    id obj = self.objArray[self.front];
    self.objArray[self.front] = NSObject.new;
    self.front = (self.front + 1) % self.capacity;
    self.count --;
    return obj;
}

- (id)nodeAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    } else {
        return self.objArray[(self.front + index) % self.capacity];
    }
}

- (id)firstNode {
    return [self nodeAtIndex:0];
}

- (id)lastNode {
    return [self nodeAtIndex:self.count - 1];
}

- (BOOL)isEmpty {
    return _count == 0;
}

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger index, BOOL *stop))block {
    BOOL stop = NO;
    for (int i = 0;i < self.count;i ++) {
        
        id obj = [self nodeAtIndex:i];
        
        block(obj, i, &stop);
        
        if (stop) {
            break;
        }
    }
}



@end
