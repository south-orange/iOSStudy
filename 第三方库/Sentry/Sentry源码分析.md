## Sentry源码分析
### 基础功能分析
- SentrySDK 程序入口
- SentryOptions 用于存储各种Sentry的配置
- SentrySession 用于保存项目运行状况
- SentryClient 用于处理数据的发送
- SentryHub 封装SentryClient并处理SentrySession逻辑
- SentryFileManeger 用于处理文件读写
- SentryMessage 信息
  - formatted
  - message
  - params
- SentryBreadcrumb 面包屑
  - level
  - category
  - timestamp
  - type
  - message
  - data
- SentryEvent 事件
  - eventId
  - message
  - error
  - timestamp
  - startTimestamp
  - level
  - platform
  - logger
  - serverName
  - releaseName
  - dist
  - environment
  - transaction
  - type
  - tags
  - extra
  - sdk
  - modules
  - fingerprint
  - user
  - context
  - threads
  - exceptinos
  - stacktrace
  - debugMeta [SentryDebugMeta]
  - breadcrumbs [SentryBreadcrumb]
- SentryEnvelopeHeader
    - eventId
    - sdkInfo sentry信息，值固定不变
    - traceContext trace信息
- SentryEnvelopeItem
  - header SentryEnvelopeHeader
  - data payload
- SentryEnvelope
  - header SentryEnvelopeHeader
  - items [SentryEnvelopeItem]
- SentryHttpTransport 用于提供发送Envelope相关的接口
- SentryTransportAdapter SentryClient和SentryTransport的中间层，将其他类型的数据转化为SentryEnvelope，目的是为了减小SentryClient，便于测试
- SentryInAppLogic 用于检测framework是否属于app
- SentryCrashStackEntryMapper 用于转换其他对象为SentryFrame的中间件
- SentryStacktraceBuilder 用于获取堆栈信息
- SentryThreadInspector  用于获取线程信息
- SentryScope 用于存储用户信息，包括User, TagValue

### 崩溃检测和监控
在[SentrySDK installIntegrations]会处理options中的integrations，每个integration表示一种检测手段
默认提供了以下integration
```
+ (NSArray<NSString *> *)defaultIntegrations
{
    return @[
        @"SentryCrashIntegration",
#if SENTRY_HAS_UIKIT
        @"SentryANRTrackingIntegration", @"SentryScreenshotIntegration",
        @"SentryUIEventTrackingIntegration", @"SentryViewHierarchyIntegration",
#endif
        @"SentryFramesTrackingIntegration", @"SentryAutoBreadcrumbTrackingIntegration",
        @"SentryAutoSessionTrackingIntegration", @"SentryAppStartTrackingIntegration",
        @"SentryOutOfMemoryTrackingIntegration", @"SentryPerformanceTrackingIntegration",
        @"SentryNetworkTrackingIntegration", @"SentryFileIOTrackingIntegration",
        @"SentryCoreDataTrackingIntegration"
    ];
}
```

- SentryCrash
  处理崩溃，崩溃日志存放在/Library/Caches/SentryCrashReports
- SentryCrashWrapper
  处理一些状态信息和app信息
- SentryBaseIntegration
  所有integration的基类，提供了配置是否可用的相关方法
- SentryCrashIntegration
-
