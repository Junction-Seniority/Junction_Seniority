//
//  CustomNavigationBar.swift
//  Seniority
//
//  Created by 이현주 on 8/24/25.
//

import SwiftUI
import UIKit

struct CustomNavigationBar: View {

    @Environment(\.dismiss) private var dismiss

    private let title: String
    private let tintColor: Color

    init(
        title: String,
        tintColor: Color = Color.primeDark,
    ) {
        self.title = title
        self.tintColor = tintColor
    }

    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                // 항상 뒤로가기 버튼 노출
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.regular)
                        .frame(width: 44, height: 44)
                }

                Spacer()

                Color.clear.frame(width: 44, height: 44)
            }

            Text(title)
                .subHead01_20Bold()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .accessibilityAddTraits(.isHeader)
        }
        .foregroundStyle(tintColor)
        .padding(.top, topSafeAreaInset)
    }

    // 기존 방식 유지 (필요시 safeAreaInset modifier로 대체 가능)
    private var topSafeAreaInset: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
            .first ?? 0
    }
}

// MARK: - 뒤로가기 스와이프
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
  open override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }

  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}

#Preview {
ZStack(alignment: .top) {
    Color.black
    CustomNavigationBar(
      title: "오늘의 알림장"
    )
  }
  .ignoresSafeArea()
}
