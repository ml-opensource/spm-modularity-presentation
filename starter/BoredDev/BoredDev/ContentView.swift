//
//  ContentView.swift
//  BoredDev
//
//  Created by Cristian Diaz on 19.01.22.
//

import IdentifiedCollections
import SwiftUI

enum Tab {
    case gallery, designer, settings
}

class AppViewModel: ObservableObject {
    @Published var selectedBoredDeViewModel: BoredDevViewModel
    @Published var galleryViewModel: GalleryViewModel
    @Published var selectedTab: Tab
    
    init(
        selectedBoredDevViewModel: BoredDevViewModel = .init(),
        galleryViewModel: GalleryViewModel = .init(),
        selectedTab: Tab = .gallery
    ) {
        self.selectedBoredDeViewModel = selectedBoredDevViewModel
        self.galleryViewModel = galleryViewModel
        self.selectedTab = selectedTab
        
        galleryViewModel.onCreate = { [weak self] in
            self?.bind(boredDeViewModel: .init())
            self?.selectedTab = .designer
        }
        
        galleryViewModel.onEdit = { [weak self] boredDeViewModel in
            self?.bind(boredDeViewModel: boredDeViewModel)
            self?.selectedTab = .designer
        }
        
        bind(boredDeViewModel: selectedBoredDevViewModel)
    }
    
    private func bind(boredDeViewModel: BoredDevViewModel) {
        self.selectedBoredDeViewModel = boredDeViewModel
        boredDeViewModel.onSave = { [weak self] in
            self?.galleryViewModel.addBoredDev(boredDev: boredDeViewModel.boredDev)
            self?.selectedTab = .gallery
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        TabView(selection: self.$viewModel.selectedTab) {
            GalleryView(viewModel: viewModel.galleryViewModel)
                .tabItem { Label("Gallery", systemImage: "person.2.crop.square.stack") }
                .tag(Tab.gallery)
            
            DesignerView(viewModel: viewModel.selectedBoredDeViewModel)
                .tabItem { Label("Designer", systemImage: "circle.hexagongrid.circle") }
                .tag(Tab.designer)
            
            Text("Settings")
                .tabItem { Label("Settings", systemImage: "brain") }
                .tag(Tab.settings)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: .init(
                galleryViewModel: .init(
                    collection: [
                        .init(boredDev: BoredDev(name: "Mocky", color: .purple)),
                        .init(boredDev: BoredDev(name: "Imistan", color: .orange)),
                        .init(boredDev: BoredDev(name: "Timic", color: .teal)),
                        .init(boredDev: BoredDev(name: "Simonlated", color: .indigo)),
                        .init(boredDev: BoredDev(name: "Carl Faux", color: .gray))
                    ]
                ),
                selectedTab: .gallery
            )
        )
    }
}
