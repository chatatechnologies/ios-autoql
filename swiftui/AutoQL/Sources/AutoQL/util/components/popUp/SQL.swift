//
//  SwiftUIView.swift
//  
//
//  Created by Vicente Rincon on 09/02/22.
//

import SwiftUI

struct SQLPopUp: View {
    @Binding var isPresented: Bool
    @State var value = ""
    var sqlInfo = """
        select
          sum(sale_line.amount)
        from
          sale_line
        where
          to_timestamp(sale_line.txndate) between '2022-01-01T00:00:00.000Z'
          and '2022-01-31T23:59:59.000Z'
        order by
          sum(sale_line.amount) desc
    """
    var body: some View {
        ZStack{
            HStack{
                VStack{
                    HStack{
                        QLText(label: "GenerateSQL", padding: 0, fontSize: 20)
                    }
                    Divider()
                    HStack{
                        QLText(
                            label: sqlInfo,
                            padding: 8
                        ).background(qlBackgroundColorSecondary)
                    }
                    HStack{
                        QLButton(label: "OK", onClick: {
                            isPresented.toggle()
                        })
                    }
                }.padding(32)
            }
            .background(
                AnyView(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(qlBackgroundColorPrimary)
                )
            )
            .padding(16)
        }
    }
}


