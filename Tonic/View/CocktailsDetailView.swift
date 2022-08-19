//
//  CocktailsDetailView.swift
//  Tonic
//

import SwiftUI

struct CocktailsDetailView: View {
    
    // MARK: - Properties: private
    
    @State private var cocktail: Cocktail
    @State private var error: Bool = false
    
    private let dismiss: (() -> Void)
    
    // MARK: - Init
    
    init(_ cocktail: Cocktail, _ dismiss: @escaping (() -> Void)) {
        self.cocktail = cocktail
        self.dismiss = dismiss
    }
    
    // MARK: - Methods: private
    
    func load() async {
        guard let url = APIRequest.destination(APIRequest(.cocktail(cocktail.id)).path) else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let decodedCocktail = try? JSONDecoder().decode(Cocktail.self, from: data) {
                cocktail = decodedCocktail
            } else {
                self.error = true
            }
        } catch {
            self.error = true
        }
    }
        
    // MARK: - View
    
    @ViewBuilder
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                                                
                        Button(action: dismiss) {
                            Image("Exit")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .padding([.top, .trailing], 15)
                        }
                        .zIndex(10)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    if let cachedImage = APIClient.imageCache.object(forKey: cocktail.imageUrl as NSString) {
                        Image(uiImage: cachedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height: 320)
                            .border(Color(UIColor.label), width: 3)
                            .padding(.top, 75)
                            .clipped()
                    } else {
                        AsyncImage(url: URL(string: cocktail.imageUrl)) { status in
                            if let image = status.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 250, height: 320)
                                    .border(Color(UIColor.label), width: 3)
                                    .padding(.top, 75)
                                    .clipped()
                            } else {
                                ProgressView()
                                    .frame(width: 250, height: 320)
                                    .border(Color(UIColor.label), width: 3)
                                    .padding(.top, 75)
                           }
                        }
                    }
                    
                    Text(cocktail.name)
                        .font(.custom("GopherText-Bold", size: 30))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .bottom], 5)
                    
                    HeaderView(header: "Ingredients")
                    
                    if let ingredients = cocktail.ingredients {
                        ForEach(ingredients) { ingredient in
                            if let measure = ingredient.measure {
                                let trimmedMeasure = measure.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                
                                TextView(text: ingredient.name + " ( \(trimmedMeasure) )")
                            } else {
                                TextView(text: ingredient.name)
                            }
                        }
                    }
                    
                    HeaderView(header: "Instructions")
                    
                    if let instructions = cocktail.instructions {
                        TextView(text: instructions)
                    }
                    
                    HeaderView(header: "Glass")
                    
                    if let glass = cocktail.glass {
                        TextView(text: glass)
                    }
                    
                    Spacer()
                }
                .alert("Oops...", isPresented: $error, actions: {

                }, message: {
                    Text(NSLocalizedString("cocktails.error", comment: ""))
                })
                .task {
                    await load()
                }
                .padding([.leading, .trailing], 20)
            }
        }
        .background(Color("Cream"))
    }
}

/// Header view for the title of a section.
private struct HeaderView: View {
    var header: String
    
    @ViewBuilder
    var body: some View {
        Text(header)
            .foregroundColor(Color(UIColor.systemBackground))
            .font(.custom("GopherText-Medium", size: 20))
            .underline()
            .background(Color(UIColor.label))
    }
}

/// Text view for the description of a section.
private struct TextView: View {
    var text: String
    
    @ViewBuilder
    var body: some View {
        Text(text)
            .font(.custom("GopherText-Regular", size: 17))
    }
}
