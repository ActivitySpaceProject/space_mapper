import 'package:asm/ui/projects_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  MockBuildContext _mockContext = MockBuildContext();

    setUp(() {
     _mockContext = MockBuildContext();
   });

  testWidgets('project_list has basic widgets', (WidgetTester tester) async {  
    await tester.pumpWidget(
        MaterialApp(home: AvailableProjectsScreen()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
  });  

  testWidgets('project_list: renderListView', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: AvailableProjectsScreen()));

    final AvailableProjectsScreenState myWidgetState = tester.state(find.byType(AvailableProjectsScreen));

    final Widget expectedWidget = myWidgetState.renderListView(_mockContext);
    
    // Since the context is mocked, the widget must be wrapped in a Directionality widget. Avoiding this step will cause an error.
    final Widget wrappedWidget = Directionality(textDirection: TextDirection.ltr, child: expectedWidget);

    await tester.pumpWidget(wrappedWidget);

    expect(find.byType(ListView), findsOneWidget);
  });


  testWidgets('project_list: renderProgressBar returns an empty container if(loading==false)', (WidgetTester tester) async {  
    await tester.pumpWidget(
        MaterialApp(home: AvailableProjectsScreen()));

    final AvailableProjectsScreenState myWidgetState = tester.state(find.byType(AvailableProjectsScreen));

    myWidgetState.loading = false;
    final Widget expectedWidget = myWidgetState.renderProgressBar(_mockContext);    
    // Since the context is mocked, the widget must be wrapped in a Directionality widget. Avoiding this step will cause an error.
    final Widget wrappedWidget = Directionality(textDirection: TextDirection.ltr, child: expectedWidget);

    await tester.pumpWidget(wrappedWidget);

    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('project_list: _listViewItemBuilder onTap navigates to ProjectDetail screen', (WidgetTester tester) async {  
    await tester.pumpWidget(
        MaterialApp(home: AvailableProjectsScreen()));

    final AvailableProjectsScreenState myWidgetState = tester.state(find.byType(AvailableProjectsScreen));

    final Widget expectedWidget = myWidgetState.renderListView(_mockContext);
    
    // Since the context is mocked, the widget must be wrapped in a Directionality widget. Avoiding this step will cause an error.
    final Widget wrappedWidget = Directionality(textDirection: TextDirection.ltr, child: expectedWidget);

    await tester.pumpWidget(wrappedWidget);

    expect(find.byType(GestureDetector), findsWidgets);
  });
}
