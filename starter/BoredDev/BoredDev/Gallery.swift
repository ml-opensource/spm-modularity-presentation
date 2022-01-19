//
//  Gallery.swift
//  BoredDev
//
//  Created by Cristian Diaz on 19.01.22.
//

import IdentifiedCollections
import SwiftUI

class GalleryViewModel: ObservableObject {
    @Published var collection: IdentifiedArrayOf<BoredDevViewModel>
    
    var onCreate: () -> Void = {}
    var onEdit: (BoredDevViewModel) -> Void = { _ in }

    
    init(collection: IdentifiedArrayOf<BoredDevViewModel> = []) {
        self.collection = collection
        
        for boredDevViewModel in collection {
            self.bind(viewModel: boredDevViewModel)
        }
    }
    
    private func bind(viewModel: BoredDevViewModel) {
        viewModel.onDestroy = { [weak self, boredDev = viewModel.boredDev] in
            self?.destroy(boredDev: boredDev)
        }
        viewModel.onDuplicate = { [weak self, boredDev = viewModel.boredDev] in
            withAnimation {
                self?.duplicate(boredDev: boredDev)
            }
        }
    }
    
    private func duplicate(boredDev: BoredDev) {
        self.addBoredDev(boredDev: boredDev.duplicate())
        
    }
    
    func addBoredDev(boredDev: BoredDev) {
        let viewModel: BoredDevViewModel = .init(boredDev: boredDev)
        self.bind(viewModel: viewModel)
        if let index = self.collection.firstIndex(where: { $0.id == viewModel.id }) {
            self.collection.remove(at: index)
            self.collection.insert(viewModel, at: index)
        } else {
            _ = self.collection.append(viewModel)
        }
    }
    
    private func destroy(boredDev: BoredDev) {
        _ = self.collection.remove(id: boredDev.id)
    }
}

struct GalleryView: View {
    let columns: [GridItem] = [.init(.adaptive(minimum: 100, maximum: 200))]
    @ObservedObject var viewModel: GalleryViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(self.viewModel.collection) { boredDevViewModel in
                        Button(
                            action: { viewModel.onEdit(boredDevViewModel) },
                            label: {
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(boredDevViewModel.boredDev.color ?? .secondary)
                                            .aspectRatio(1/1, contentMode: .fit)
                                        
                                        Text(boredDevViewModel.boredDev.id.uuidString)
                                            .allowsTightening(true)
                                            .font(.caption2)
                                            .rotation3DEffect(.degrees(-35), axis: (1, 1, 1))
                                            .blendMode(.overlay)
                                    }
                                    
                                    Text(boredDevViewModel.boredDev.name)
                                        .font(.footnote)
                                }
                                .contextMenu {
                                    Button(
                                        action: { boredDevViewModel.onDuplicate() },
                                        label: { Label("Duplicate", systemImage: "person.2") }
                                    )
                                    
                                    Button(
                                        action: { viewModel.onEdit(boredDevViewModel) },
                                        label: { Label("Edit", systemImage: "pencil") }
                                    )
                                    
                                    Button(
                                        action: { boredDevViewModel.onDestroy() },
                                        label: { Label("Destroy", systemImage: "rays") }
                                    )
                                }
                            }
                        )
                            .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Gallery")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(
                        action: { self.viewModel.onCreate() },
                        label: { Image(systemName: "person.crop.circle.fill.badge.plus") }
                    )
                        .accessibility(label: Text("Create new bored dev"))
                }
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(
            viewModel: .init(
                collection: [
                    .init(boredDev: BoredDev(name: "Mocky", color: .purple)),
                    .init(boredDev: BoredDev(name: "Imistan", color: .orange)),
                    .init(boredDev: BoredDev(name: "Timic", color: .teal)),
                    .init(boredDev: BoredDev(name: "Simonlated", color: .indigo)),
                    .init(boredDev: BoredDev(name: "Carl Faux", color: .gray))
                ]
            )
        )
    }
}
