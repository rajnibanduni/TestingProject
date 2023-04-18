//
//  StepsTrackerView.swift
//  Infits
//
//  Created by Chitrala Dhruv on 23/01/23.
//

import SwiftUI

struct StepsTrackerView: View {
    @State var steps: Int = 0
    @State var goal: Int = 160
    @State var calories: Int = 0
    @State var AvgSpeed: Int = 0
    @State var distance: Int = 0
    
    private var healthStore: HealthStore?
    
    @State var isSetGoal:Bool = false
    @State var goalSetValue = ""
    var value = ""
    
    
    init() {
        healthStore = HealthStore()
    }
    
    var body: some View {
        
        
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color(red: 1.00, green: 0.50, blue: 0.42),Color(red: 1.00, green: 0.36, blue: 0.00)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                    .toolbar  {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                //isShowing.toggle()
                            }) {
                                Image("backArrow")
                                    .renderingMode(.original)
                            }
                        }
                        ToolbarItem(placement: .principal) {
                            Text("STEPS").font(.system(size: 30))
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                
                VStack {
                    ZStack {
                        Circle()
                            .trim(from:0, to: 0.6)
                            .stroke(.white.opacity(0.3),lineWidth: 4)
                            .frame(width: 280)
                            .rotationEffect(.init(degrees: 145))
                        
                        let num = Double(steps)/Double(goal)*0.6
                        
                        Circle()
                            .trim(from:0, to: num > 0.6 ? 0.6 : num)
                            .stroke(.white.opacity(0.8),lineWidth: 4)
                            .frame(width: 280)
                            .rotationEffect(.init(degrees: 145))
                        
                        let angle = Double(steps)*216/Double(goal)
                        
                        Circle()
                            .fill(.white.opacity(0.8))
                            .frame(width: 15)
                            .offset(x: -115, y: 79)
                            .rotationEffect(.init(degrees: angle > 216 ? 216 : angle))
                        VStack {
                            Image("Trophy")
                            Text(goal.description)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .bold()
                        }
                        .position(x:UIScreen.main.bounds.width - 75, y:190)
//                        .offset(x: 140, y: 50)
                        
                        VStack {
                            Image("foot")
                            
                            Text(steps.description)
                                .foregroundColor(.white)
                                .font(.system(size: 35))
                                .bold()
                                .onAppear {
                                    if let healthStore = healthStore {
                                        healthStore.requestAuthorisation { success in
                                            if success {
                                                healthStore.getTodaysSteps { sum in
                                                    steps = Int(sum)
                                                }
                                            }
                                        }
                                    }
                                }
                            
                            //Set Goal Button
                            Button {
                                self.isSetGoal.toggle()
                            } label: {
                                Text("Set Goal")
                                    .font(Font.custom("NATS 400", size: 18))
//                                    .padding(15)
                                    .frame(width: 120, height: 50)
                                    .foregroundColor(Color(red: 255 / 255, green: 129 / 255, blue: 109 / 255).opacity(1))

                                    .background(.white)
                                    .clipShape(Rectangle())
                                    .cornerRadius(50)
                                    .shadow(color:Color(#colorLiteral(red: 0.69, green: 0.75, blue: 0.77, alpha: 0.32)), radius: 6, x: 0, y: 8)
                            }
                            
//                            Rectangle()
//                                .cornerRadius(20)
//                                .frame(width: 100, height: 35)
//                                .foregroundColor(.white)
//                                .overlay(Button {
//                                    SetGoalView()
//                                    print("Edit button was tapped")
//                                } label: {
//                                    Text("Set Goal")
//                                        .foregroundColor(.black)
//                                        .font(.system(size: 14))
//                                        .bold()
//                                })
                            
                            
                        }.animation(.spring())
                    }
                    HStack {
                        //Spacer()
                        ExtractedView(parameter: "Calories", value: calories, units: "kCal")
                            .padding(.all,10)
                            .onAppear {
                                if let healthStore = healthStore {
                                    healthStore.requestAuthorisation { success in
                                        if success {
                                            healthStore.getEnergyConsumed { totalCaloriesConsumed in
                                                calories = Int(totalCaloriesConsumed!)
                                            }
                                        }
                                    }
                                }
                            }
                        
                        Image("Line")
                            .padding(.all,10)
                        
                        ExtractedView(parameter: "Avg. Speed", value: AvgSpeed, units: "Km/h")
                            .padding(.all,10)
                            .onAppear {
                                if let healthStore = healthStore {
                                    healthStore.requestAuthorisation { success in
                                        if success {
                                            healthStore.getAvgSpeed { avg in
                                                AvgSpeed = Int(avg!*3.6)
                                            }
                                        }
                                    }
                                }
                            }
                        Image("Line")
                            .padding(.all,10)
                        ExtractedView(parameter: "Distance", value: distance, units: "Km")
                            .padding(.all,10)
                            .onAppear {
                                if let healthStore = healthStore {
                                    healthStore.requestAuthorisation { success in
                                        if success {
                                            healthStore.getDistance { distanceWalked in
                                                distance = Int(distanceWalked!/1000)
                                            }
                                        }
                                    }
                                }
                            }

                    }
                    
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                    
                    PastActivityView(col: Color(red: 1.00, green: 0.60, blue: 0.45))
                        .cornerRadius(15)
                        .ignoresSafeArea()
                    
                        .sheet(isPresented: .constant(false)) {
                            PastActivityView(col: Color(red: 1.00, green: 0.60, blue: 0.45))
                                .presentationDetents([.large])
                            //.interactiveDismissDisabled()
                            
                        }
                    
                    
                    Spacer()
                }
                .edgesIgnoringSafeArea(.bottom)
                if isSetGoal {
                    setGoalViewAlert(isSetGoal: $isSetGoal)
                    
                }
            }
//            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
}

struct StepsTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        StepsTrackerView()
    }
}


struct ExtractedView: View {
    var parameter: String
    var value: Int
    var units: String
    var body: some View {
        VStack(spacing: 0) {
            Text(parameter)
                .font(Font.custom("NATS 400", size: 18))
                .foregroundColor(Color(red: 255 / 255, green: 209 / 255, blue: 197 / 255).opacity(1))
                .padding(.bottom, 5)
            Text(value.description)
                .font(Font.custom("NATS 400", size: 30))
                .foregroundColor(.white)
                .padding(.bottom, 5)
            Text(units.description)
                .font(Font.custom("NATS 400", size: 18))
                .foregroundColor(Color(red: 255 / 255, green: 209 / 255, blue: 197 / 255).opacity(1))
            
        }.foregroundColor(.white)
    }
}

//Number Only
class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter{$0.isNumber}
            if value != filtered {
                value = filtered
            }
        }
    }
     
}
 
struct setGoalViewAlert:View{
//    @State var goalSetValue = ""
    @Binding var isSetGoal:Bool
 
    @ObservedObject var goalSetValuetxt = NumbersOnly()
    
    var body: some View {
        ZStack {
            VStack{
                VStack (alignment: .trailing){
                    Button {
                        self.isSetGoal.toggle()
                   } label: {
                       Image(systemName: "xmark")
                           .resizable()
                           .frame(width: 15, height: 15)
                           .foregroundColor(Color(red: 0 / 255, green: 0 / 255, blue: 0 / 255).opacity(1))
                   }
                   .frame(maxWidth: .infinity, alignment:.trailing)
                }
                 HStack{
                    Text("Set Daily Steps Goal")
                        .font(Font.custom("NATS 400", size: 22  ))
                        .foregroundColor(Color(red: 0 / 255, green: 0 / 255, blue: 0 / 255).opacity(1))
                        .padding(.top, 15)
                }
                
                TextField(
                  "Set Goal here..",
                  text:$goalSetValuetxt.value
                )
                 
                .keyboardType(.numberPad)
                .padding(.all)
                .frame(width: 150, alignment: .center)
                .multilineTextAlignment(.center)
                Divider()
                    .frame(width: 150, alignment: .center)
                    .padding(.top, -10)
                    .padding(.bottom, 20)
                Button {
                    self.isSetGoal.toggle()
                 } label: {
                    Text("Save")
                        .font(Font.custom("NATS 400", size: 24))
                        .frame(width: 155, height: 45)
                        .foregroundColor(.white)
                        .background(Color(red: 255 / 255, green: 130 / 255, blue: 110 / 255) .opacity(1))
                    
                        .clipShape(Rectangle())
                        .cornerRadius(50)
                        .shadow(color:Color(#colorLiteral(red: 0.58, green: 0.68, blue: 1.0, alpha: 0.3)), radius: 6, x: 0, y: 10)
                }
                
                
            }.padding(20)
                .background(.white)
                .cornerRadius(10)
                .shadow(color:Color(red: 176 / 255, green: 190 / 255, blue: 197 / 255).opacity(0.32), radius: 15, x: 0, y: 3)
                .frame(width: UIScreen.main.bounds.width - 50)
        }
    }
}

