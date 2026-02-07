import 'package:flutter/material.dart';
import 'package:menurecommend/services/api_service.dart';

import 'package:menurecommend/screen/result_screen.dart';
import 'package:menurecommend/widgets/custom_scaffold.dart';

class AddquestionScreen extends StatefulWidget {
  final String menuName;
  final Map<String, dynamic> originalChoices;

  const AddquestionScreen({
    super.key,
    required this.menuName,
    required this.originalChoices,
  });

  @override
  State<AddquestionScreen> createState() => _AddquestionScreenState();
}

class _AddquestionScreenState extends State<AddquestionScreen> {
  final TextEditingController _textController = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback({bool skip = false}) async {
    setState(() {
      isSubmitting = true;
    });

    final result = await ApiService.submitFeedback(
      menuName: widget.menuName,
      isLiked: false,
      additionalInfo: skip ? '별다른 이유 없음' : _textController.text,
      originalChoices: widget.originalChoices,
    );

    setState(() {
      isSubmitting = false;
    });

    if (result != null) {
      final newMenuData = Map<String, dynamic>.from(result);
      newMenuData['input'] = widget.originalChoices;

      if (!mounted) return;

      //ScaffoldMessenger.of(context).showSnackBar(
        //const SnackBar(content: Text('새로운 메뉴를 추천해드릴게요! 🍽️')),
      //);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(menuData: newMenuData)),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 200),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE9EEFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '아쉬웠구나 😢',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2B2B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '"${widget.menuName}"이(가) 마음에 안 들었어?',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '어떤 점이 아쉬웠는지 알려줘!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset('assets/add.png', height: 200),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: _textController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: '예: 오늘은 국물 있는 음식이 더 먹고 싶었어요',
                    hintStyle: TextStyle(
                      color: Color(0xFF000000),
                    ),
                    filled: true,
                    fillColor: Color(0xFFB04CB6).withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF5B8DEF), width: 2),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: isSubmitting ? null : _submitFeedback,
                      child: Container(
                        height: 50,
                        width: 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFF9A56),
                              Color(0xFFFF6B35),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          '피드백 제출',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _submitFeedback(skip: true),
                      child: Container(
                        height: 50,
                        width: 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          '건너뛰기',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}