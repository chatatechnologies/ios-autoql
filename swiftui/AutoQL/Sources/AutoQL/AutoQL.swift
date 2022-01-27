import SwiftUI
struct StartAutoQL: View{
    @State var showingChat = false
    var body: some View{
        ZStack{
            Group{
                if showingChat{
                    WindowChatView(showingChat: $showingChat)
                } else {
                    ButtonAutoQL(showingChat: $showingChat)
                }
            }
        }
    }
}
public func getButton() -> some View {
    return StartAutoQL()
}
