//
//  HistoryView.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/6/22.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.sessions, id: \.self) { session in
                    HistoryRowView(viewModel: createHistoryRowViewModel(for: session))
                        .padding([.top, .bottom])
                }
                .onDelete { indices in
                    viewModel.delete(at: indices)
                }
            }
        }
    }
    
    private func createHistoryRowViewModel(for session: Session) -> HistoryRowViewModel {
        return HistoryRowViewModel(session: session)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(viewModel: HistoryViewModel(viewContext: PersistenceController.preview.container.viewContext))
    }
}
