//
//  File.swift
//  
//
//  Created by Vicente Rincon on 15/03/22.
//

import Foundation
import SwiftUI
struct AutoCompleteView: View{
    @Binding var value: String
    @Binding var queries: [String]
    var onFunc: () -> Void
    var body: some View{
        HStack{
            VStack{
                ForEach(queries, id: \.self){ query in
                    HStack{
                        Button{
                            value = query
                            onFunc()
                        } label: {
                            HStack{
                                QLText(label: query, aligment: .leading)
                                Spacer()
                            }.frame(maxWidth: .infinity, maxHeight: 40)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(QLRoundedView(cornerRadius: 10))
    }
}
