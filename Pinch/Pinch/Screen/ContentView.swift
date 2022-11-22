//
//  ContentView.swift
//  Pinch
//
//  Created by Bertuğ Horoz on 21.11.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimating : Bool = false
    @State private var imageScale : CGFloat = 1
    @State private var imageOffset : CGSize = .zero
    @State private var isDrawerOpen : Bool = false
    
    let pages : [Page] = pageData
    @State private var pageIndex : Int = 1
    
    // FUNCTION
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                // PAGE IMAGE
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x : imageOffset.width , y : imageOffset.height)
                    .scaleEffect(imageScale)
                // TAP GESTURE
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            resetImageState()
                        }
                    })
                // SRAG GESTURE
                    .gesture(
                        DragGesture()
                            .onChanged {value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded { _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                        )
                // MAGNIFICATION
                    .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            withAnimation(.linear(duration: 1)) {
                                if imageScale >= 1 && imageScale <= 5 {
                                    imageScale = value
                                } else if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                        }
                        .onEnded { _ in
                            if imageScale > 5 {
                                imageScale = 5
                            } else if imageScale <= 1 {
                                resetImageState()
                            }
                        }
                    )
            } // ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform:  {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            })
            // INFO PANEL
            .overlay(InfoPanelView(scale: imageScale, offset: imageOffset)
                .padding(.horizontal)
                .padding(.top, 30)
            , alignment: .top)
            //CONTROLS
            .overlay(
                Group{
                    HStack {
                        //SCALE DOWN
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        //RESET
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        //SCALEUP
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    } // : CONTROLS
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
            }
                    .padding(.bottom, 30)
                , alignment: .bottom)
            // DRAWER
                .overlay(
                    HStack (spacing: 12){
                        //DRAWER HANDLE
                        Image(systemName:  isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height : 40)
                            .padding(8)
                            .foregroundStyle(.secondary)
                            .onTapGesture(perform: {
                                withAnimation(.easeOut) {
                                    isDrawerOpen.toggle()
                                }
                            })
                        // THUMBNAILS
                        ForEach(pages) { page in
                            Image(page.thumbnailName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                .cornerRadius(8)
                                .shadow(radius: 4)
                                .opacity(isDrawerOpen ? 1 : 0)
                                .animation(.easeOut(duration: 0.4), value: isDrawerOpen)
                                .onTapGesture(perform: {
                                    isAnimating = true
                                    pageIndex = page.id
                                })
                        }
                        Spacer()
                    } // :DRAWER
                        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .opacity(isAnimating ? 1 : 0)
                        .frame(width: 260)
                        .padding(.top, UIScreen.main.bounds.height / 12)
                        .offset(x: isDrawerOpen ? 20 : 215)
                    , alignment: .topTrailing
                )
        } // NavigationView
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}