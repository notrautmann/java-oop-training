package alex_tdd_1;

//OrderServiceTest.java
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

 @Mock
 private OrderRepository orderRepository;

 @InjectMocks
 private OrderService orderService;

 @Test
 void shouldSaveValidOrder() {
     Order order = new Order("book", 2);

     orderService.placeOrder(order);

     verify(orderRepository).save(order); // Mockito-Verifikation
 }
}
