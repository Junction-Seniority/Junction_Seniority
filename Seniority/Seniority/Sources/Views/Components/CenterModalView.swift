
import SwiftUI

struct ReportCreateCompleteModal: View {
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color(.black70)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                Image("point")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)

                VStack(spacing: 4) {
                    Text("오늘의 알잘딱깔쌤 완료")
                        .head01_24Bold()
                        .foregroundColor(Color.prime100)
                    Text("선생님의 따뜻한 마음이 알림장에 담겼습니다")
                        .body03_14Light()
                        .foregroundColor(Color.black70)
                }

                Button(action: onConfirm) {
                    Text("확인")
                        .body01_16Bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color("prime100"))
                        .cornerRadius(12)
                }
            }
            .padding(.all, 24)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    ReportCreateCompleteModal(onConfirm: {
        print("확인")
    })
}
