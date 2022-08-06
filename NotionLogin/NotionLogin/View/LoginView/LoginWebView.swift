//
//  LoginWebView.swift
//  NotionLogin
//
//  Created by una on 2021/12/20.
//

import UIKit
import SwiftUI
import WebKit
import Combine

protocol WebViewHandlerDelegate {
    func recivedTokenCode(code: String)
}

struct LoginWebView: UIViewRepresentable, WebViewHandlerDelegate {

    let loginURL = "https://api.notion.com/v1/oauth/authorize?owner=user&client_id=\(Constant.clientId)&redirect_uri=\(Constant.redirect_uri)&response_type=code"


    @Binding var code: String?

    func recivedTokenCode(code: String) {
        self.code = code
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(delegate: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false  // JavaScript가 사용자 상호 작용없이 창을 열 수 있는지 여부

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences

        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator    // 웹보기의 탐색 동작을 관리하는 데 사용하는 개체
        webView.allowsBackForwardNavigationGestures = true    // 가로로 스와이프 동작이 페이지 탐색을 앞뒤로 트리거하는지 여부
        webView.scrollView.isScrollEnabled = true    // 웹보기와 관련된 스크롤보기에서 스크롤 가능 여부


        if let string = loginURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: string) {
            webView.load(URLRequest(url: url))    // 지정된 URL 요청 개체에서 참조하는 웹 콘텐츠를로드하고 탐색
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<LoginWebView>) {

    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var delegate: WebViewHandlerDelegate?

        init(delegate: WebViewHandlerDelegate) {
            self.delegate = delegate
        }

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            if let url = navigationAction.request.url,
               url.absoluteString.hasPrefix(Constant.redirect_uri) {
                let components = URLComponents(string: url.absoluteString)
                if let code = components?.queryItems?.first(where: { $0.name == "code" })?.value {
                    delegate?.recivedTokenCode(code: code)
                }
            }

            return decisionHandler(.allow)
        }
    }
}
