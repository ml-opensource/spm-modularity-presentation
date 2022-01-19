//
//  Designer.swift
//  BoredDev
//
//  Created by Cristian Diaz on 19.01.22.
//

import SwiftUI

struct BoredDev: Equatable, Identifiable {
    let id = UUID()
    var name: String
    var color: Color?
}

extension BoredDev {
    func duplicate() -> Self {
        .init(name: self.name, color: self.color)
    }
}

class BoredDevViewModel: Identifiable, ObservableObject {
    @Published var boredDev: BoredDev
    
    var id: BoredDev.ID { self.boredDev.id }
    
    var onDestroy: () -> Void = {}
    var onDuplicate: () -> Void = {}
    var onEdit:  () -> Void = {}
    var onSave: () -> Void = {}
    
    init(
        boredDev: BoredDev = .init(name: "New Bored Dev")
    ) {
        self.boredDev = boredDev
    }
}

struct DesignerView: View {
    @ObservedObject var viewModel: BoredDevViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    content: {
                        ColorPicker(
                            "Color",
                            selection: Binding(
                                get: { viewModel.boredDev.color ?? .secondary },
                                set: { viewModel.boredDev.color =  $0 }
                            )
                        )
                        
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(viewModel.boredDev.color ?? .secondary)
                            .aspectRatio(1/1, contentMode: .fit)
                            .padding(.vertical, 8)
                            .overlay(
                                Text(viewModel.boredDev.id.uuidString)
                                    .allowsTightening(true)
                                    .font(.largeTitle)
                                    .rotation3DEffect(.degrees(-35), axis: (1, 1, 1))
                                    .blendMode(.overlay)
                            )
                        
                        
                        TextField("Name", text: $viewModel.boredDev.name)
                        
                        Button(
                            action: { self.viewModel.onSave() },
                            label: { Text("Save").frame(maxWidth: .infinity) }
                        )
                            .controlSize(.large)
                            .buttonStyle(.borderedProminent)
                            .padding(.vertical, 8)
                            .accessibility(label: Text("Design a bored dev"))
                    },
                    footer: {
                        Text("\(viewModel.boredDev.id)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                )
            }
            .navigationTitle("Designer")
        }
    }
}

struct DesignerView_Previews: PreviewProvider {
    static var previews: some View {
        // DesignerView(viewModel: .init())
        DesignerView(viewModel: .init(boredDev: BoredDev(name: "Fakey", color: .yellow)))
    }
}
