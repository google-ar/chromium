// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/web/public/web_state/web_state_delegate_bridge.h"

#include "base/logging.h"
#import "ios/web/public/web_state/context_menu_params.h"

namespace web {

WebStateDelegateBridge::WebStateDelegateBridge(id<CRWWebStateDelegate> delegate)
    : delegate_(delegate) {}

WebStateDelegateBridge::~WebStateDelegateBridge() {}

WebState* WebStateDelegateBridge::OpenURLFromWebState(
    WebState* source,
    const WebState::OpenURLParams& params) {
  if ([delegate_ respondsToSelector:@selector(webState:openURLWithParams:)])
    return [delegate_ webState:source openURLWithParams:params];
  return nullptr;
}

void WebStateDelegateBridge::LoadProgressChanged(WebState* source,
                                                 double progress) {
  if ([delegate_ respondsToSelector:@selector(webState:didChangeProgress:)])
    [delegate_ webState:source didChangeProgress:progress];
}

bool WebStateDelegateBridge::HandleContextMenu(
    WebState* source,
    const ContextMenuParams& params) {
  if ([delegate_ respondsToSelector:@selector(webState:handleContextMenu:)]) {
    return [delegate_ webState:source handleContextMenu:params];
  }
  return NO;
}

JavaScriptDialogPresenter* WebStateDelegateBridge::GetJavaScriptDialogPresenter(
    WebState* source) {
  SEL selector = @selector(javaScriptDialogPresenterForWebState:);
  if ([delegate_ respondsToSelector:selector]) {
    return [delegate_ javaScriptDialogPresenterForWebState:source];
  }
  return nullptr;
}

void WebStateDelegateBridge::OnAuthRequired(
    WebState* source,
    NSURLProtectionSpace* protection_space,
    NSURLCredential* proposed_credential,
    const AuthCallback& callback) {
  AuthCallback local_callback(callback);
  if ([delegate_
          respondsToSelector:@selector(webState:
                                 didRequestHTTPAuthForProtectionSpace:
                                                   proposedCredential:
                                                    completionHandler:)]) {
    [delegate_ webState:source
        didRequestHTTPAuthForProtectionSpace:protection_space
                          proposedCredential:proposed_credential
                           completionHandler:^(NSString* username,
                                               NSString* password) {
                             local_callback.Run(username, password);
                           }];
  } else {
    local_callback.Run(nil, nil);
  }
}

}  // web
