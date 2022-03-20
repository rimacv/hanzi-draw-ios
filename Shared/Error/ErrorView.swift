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
                    .foregroundColor(.black)
                if(errorWrapper.error != nil){
                    Text(errorWrapper.error!.localizedDescription)
                        .font(.headline)
                }
               
                Text(errorWrapper.guidance)
                    .font(.caption)
                    .padding(.top)
                    .foregroundColor(.black)
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
