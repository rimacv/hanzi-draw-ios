import SwiftUI

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text(String(localized: "ErrorTitle"))
                    .font(.title)
                    .padding(.bottom)
                    .foregroundColor(.black).multilineTextAlignment(.center)
                
                if(errorWrapper.error != nil){
                    Text(errorWrapper.error!.localizedDescription)
                        .font(.headline).multilineTextAlignment(.center)
                }
               
                Text(errorWrapper.guidance)
                    .font(.subheadline)
                    .padding(.top)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding()
            .background(.white)
            .cornerRadius(16)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(String(localized:"Dismiss")) {
                        dismiss()
                    }.foregroundColor(.black)
                }
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum SampleError: Error {
        case errorRequired
    }
    
    static var wrapper: ErrorWrapper {
        ErrorWrapper(error: SampleError.errorRequired,
                     guidance: "You can safely ignore this error.")
    }
    
    static var previews: some View {
        ErrorView(errorWrapper: wrapper)
    }
}
