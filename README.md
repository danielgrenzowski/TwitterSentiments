# Twitter Sentiment Analyzer

## Synopsis
Swift project that uses IBM's AlchemyLanguage to analyze recent tweets returned by Twitter's open search API. Still a work-in-progress :)

## Deployment Info
This project is built for iOS 9.3 and above. It requires Cocoa Pods for the TwitterKit and Fabric frameworks, and Carthage to manage the required frameworks for IBM's Watson iOS SDK.

## Install Cocoa Pods
1. Ensure your podfile contains the following pods:  
  
`pod 'Fabric'`  
`pod 'TwitterKit'`  

2. Run `$ pod install`

## Install Carthage

1. Ensure your Cartfile contains the following: `github "watson-developer-cloud/ios-sdk"`  

2. Run `$ carthage update --platform iOS` in the root directory of your project and add the following frameworks to your Xcode project:  
 * RestKit  
 * Freddy  
 * AlamoFire  
 * AlchemyLanguageV1  

## Installation
`$ git clone https://github.com/danielgrenzowski/TwitterSentiments`

## License
* Created by Daniel Grenzowski  
* Powered by Twitter's open search API and IBM's Watson Developer Cloud (https://github.com/watson-developer-cloud/ios-sdk)  
* Version 1.0.1  
  
Copyright (c) 2016 DG Inc. All rights reserved.  