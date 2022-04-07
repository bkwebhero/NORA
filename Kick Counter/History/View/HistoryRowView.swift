//
//  HistoryRowView.swift
//  Kick Counter
//
//  Created by Benjamin Kelsey on 4/7/22.
//

import SwiftUI

struct HistoryRowView: View {
    
    var viewModel: HistoryRowViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.dateString)
                    .font(Font.system(size: 17))
                Spacer()
                Text(viewModel.timeString)
                    .font(Font.system(size: 14))
            }
            HStack {
                Text(viewModel.durationString)
                    .font(Font.system(size: 20))
                Spacer()
            }
        }
    }
}

struct HistoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let request = Session.fetchRequest()
        if let session = try? viewContext.fetch(request).first {
            let viewModel = HistoryRowViewModel(session: session)
            HistoryRowView(viewModel: viewModel)
                .previewLayout(.sizeThatFits)
        } else {
            Text("Preview Error: No preview data")
        }
    }
}
