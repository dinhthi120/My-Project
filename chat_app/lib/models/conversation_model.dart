class Conversations {
  final String conversationId;
  final String conversationName;
  final String creatorId;
  final List? members;
  final String recentMessage;
  final String recentSender;

  Conversations({
    this.conversationId = '',
    this.conversationName = '',
    this.creatorId = '',
    this.members,
    this.recentMessage = '',
    this.recentSender= '',
  });

  @override
  String toString() {
    return 'Conversations(conversation_id: $conversationId, conversation_name: $conversationName, creator_id: $creatorId, members: $members, recent_message: $recentMessage, recent_sender: $recentSender)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'conversation_id': conversationId,
      'conversation_name': conversationName,
      'creator_id': creatorId,
      'members': members,
      'recent_message': recentMessage,
      'recent_sender': recentSender,
    };
  }

  static Conversations fromJson(Map<String, dynamic> json) => Conversations(
    conversationId: json['conversation_id'],
    conversationName: json['conversation_name'],
    creatorId: json['creator_id'],
    members: json['members'],
    recentMessage: json['recent_message'],
    recentSender: json['recent_sender'],
  );
}