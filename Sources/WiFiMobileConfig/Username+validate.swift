public extension Username {
    static func validate(usernameText: String) -> ValidationResult<Username, FailureReason> {
        guard !usernameText.isEmpty else {
            return .invalid(because: .empty)
        }

        return .valid(content: Username(usernameText))
    }


    enum FailureReason: Error {
        case empty
    }
}
