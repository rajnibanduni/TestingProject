//
//  PastActivityView.swift
//  Infits
//
//  Created by Chitrala Dhruv on 23/01/23.
//

import SwiftUI

struct PastActivityView: View {
    var col: Color
//    var arrowColor: String
    var body: some View {
        Color.white
            .ignoresSafeArea()
            .overlay(
        ScrollView {
            VStack {
                Button{
                    
                }label: {
                    Image(systemName: "control")
                        .background(col)
                        
                }.padding(.bottom)
                HStack {
                    Image("HLine")
                    Text("Past Activity")
                        .font(.system(size: 18))
                        .bold()
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .foregroundColor(.black)
                    Image("HLine")
                }
                ForEach(0..<10) {num in
                    ActivityList(num: num, col: col)
                }
                Spacer()
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.top, 20)
            .padding(.bottom)
        })
    }
}

struct PastActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PastActivityView(col: Color(red: 1.00, green: 0.60, blue: 0.45))
    }
}

struct ActivityList: View {
    var num: Int
    var col: Color
    var body: some View {
        Rectangle()
            .cornerRadius(10)
            .frame(height: 50)
            .foregroundColor(col)
            .overlay(HStack {
                Text("\(num) Glasses")
                Spacer()
                VStack {
                    Text("15/02/22")
                        .font(.system(size: 13))
                    Text("09 : 00 AM")
                        .font(.system(size: 13))
                }.padding(.trailing)
                Button{
                    print("Button Pressed")
                } label: {
                    Image("3dots")
                }
            }
                .foregroundColor(.white)
            .padding(.leading)
            .padding(.trailing))
    }
}
