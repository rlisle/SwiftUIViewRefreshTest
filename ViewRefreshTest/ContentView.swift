//
//  ContentView.swift
//  ViewRefreshTest
//
//  This project attempts to prove when views are updated.
//
//  Created by Ron Lisle on 8/21/21.
//

import SwiftUI
import Combine

class Model: ObservableObject {
    
    @Published var var1: Bool = false
    @Published var var2: Bool = false

    let tracker = InstanceTracker("Model")

    var cancellable0: AnyCancellable!
    var cancellable1: AnyCancellable!
    var cancellable2: AnyCancellable!

    init() {
        cancellable0 = objectWillChange.sink { (value) in
            self.tracker("objectWillChange sink received change notification")
        }
        cancellable1 = $var1.sink { (value) in
            self.tracker("var1 sink received change notification")
        }
        cancellable2 = $var2.sink { (value) in
            self.tracker("var2 sink received change notification")
        }
    }
}

struct ContentView: View {
    
    @StateObject var model = Model()
    
    @State private var var3: Bool = false
    @State private var var4: Bool = false
    
    let tracker = InstanceTracker("ContentView")
    
    var body: some View {
        VStack(alignment: .leading) {

            Group {
                Text("The following 4 views track:")
                Text("  * @ObservedObject var1 and var2")
                Text("  * @State var3 and var4")
                    .padding(.bottom, 8)
                Text("Observe the console for init messages")
            }
            .padding(0)

            view1()
                .environmentObject(model)
                .padding(0)
            view2()
                .environmentObject(model)
                .padding(0)
            view3(var3: var3)
                .padding(0)
            view4(var4: var4)
                .padding(0)

            VStack(alignment: .center) {
                Text("Use the following buttons to set/clear the ObservedObject variables")
                    .lineLimit(nil)
                    .padding(.bottom,16)
                
                Button(action: {
                    model.var1.toggle()
                }, label: {
                    Text("\(model.var1 ? "Clear " : "Set ") @ObservedModel.var1")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(8)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(16.0)
                })
                .padding(.bottom,8)
                
                Button(action: {
                    model.var2.toggle()
                }, label: {
                    Text("\(model.var2 ? "Clear " : "Set ") @ObservedModel.var2")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(8)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(16.0)
                })
                .padding(.bottom, 24)
                
                
                Text("Use the following buttons to set/clear the @State variables")
                    .lineLimit(nil)
                    .padding(.bottom,16)
                
                Button(action: {
                    var3.toggle()
                    print("var3 is \(var3 ? "On" : "Off")")
                }, label: {
                    Text("\(var3 ? "Clear " : "Set ") @State var3")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16.0)
                })
                .padding(.bottom,8)
                
                Button(action: {
                    var4.toggle()
                    print("var4 is \(var4 ? "On" : "Off")")
                }, label: {
                    Text("\(var4 ? "Clear " : "Set ") @State var4")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(16.0)
                })
            }
        }
        .padding(16)
    }
}

struct view1: View {

    @EnvironmentObject var model: Model
    
    let tracker = InstanceTracker("view1")

    var body: some View {
        VStack {
            Text("model.var1 is \(model.var1 ? "On" : "Off")")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.orange)
    }
}

struct view2: View {

    @EnvironmentObject var model: Model

    let tracker = InstanceTracker("view2")

    var body: some View {
        VStack {
            Text("var2 is \(model.var2 ? "On" : "Off")")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.purple)
    }
}

struct view3: View {

    var var3: Bool
    
    let tracker = InstanceTracker("view3")

    var body: some View {
        VStack {
            Text("@State var3 is \(var3 ? "On" : "Off")")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.blue)
    }
}

struct view4: View {

    var var4: Bool
    
    let tracker = InstanceTracker("view4")

    var body: some View {
        VStack {
            Text("@State var4 is \(var4 ? "On" : "Off")")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
