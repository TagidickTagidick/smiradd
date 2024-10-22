import SwiftUI
import Shimmer

struct MyTeamView: View {
    let createTeam: (() -> ())
    let openTeam: (() -> ())
    
    @Binding var isSheet: Bool
    let openNewCard: (() -> ())
    
    @EnvironmentObject private var commonViewModel: CommonViewModel
    
    var body: some View {
        VStack {
            ProfileTileView(
                text: "Моя команда",
                onTap: {
                    self.createTeam()
                },
                showButton: self.commonViewModel.myTeamMainModel == nil
            )
            Spacer()
                .frame(height: 20)
            if self.commonViewModel.myTeamMainModel == nil {
                ProfileNoCardsView(
                    title: "У вас пока нет команды",
                    description: "Создайте визитную карту вашей команды или организации",
                    onTap: {
                        self.createTeam()
                    }
                )
                .customAlert(
                    "Создайте визитку",
                    isPresented: self.$isSheet,
                    actionText: "Да",
                    isRed: false
                ) {
                    self.openNewCard()
                } message: {
                    Text("Вы должны создать свою визитку, чтобы открыть возможность создавать команду. Хотите сделать это сейчас?")
                        .font(
                            .custom(
                                "OpenSans-Regular",
                                size: 14
                            )
                        )
                        .foregroundStyle(textDefault)
                }
            }
            else {
                MyTeamCardView(
                    teamMainModel: self.commonViewModel.myTeamMainModel!
                )
                    .onTapGesture {
                        self.openTeam()
                    }
            }
        }
    }
}
