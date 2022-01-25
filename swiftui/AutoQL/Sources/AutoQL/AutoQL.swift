import SwiftUI

public struct HomeAutoQL: View{
    public var body: some View{
        ZStack{
            Text("AutoQL2.0")
        }
    }
}
public func getButton() -> some View {
    var body: some View{
        ZStack{
            Text("AutoQL2.0")
        }
    }
    return body
}
extension View {
    public func centerH() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
}
