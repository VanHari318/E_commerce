// services/mock_data.dart
import 'dart:math';
import '../models/product.dart';

const List<String> mockCategories = [
  "Điện tử",
  "Quần áo",
  "Giày dép",
  "Phụ kiện",
  "Gia dụng",
];

final _random = Random(42); // Fixed seed for reproducible random tags

String _getRandomTag() {
  const tags = ['Yêu thích', 'Giảm 50%', 'Mall', 'Mới', 'Flash Sale', ''];
  return tags[_random.nextInt(tags.length)];
}

final List<Product> mockProducts = [
  // Điện tử (Electronics)
  Product(id: 1, title: 'Điện thoại Smartphone X Promax 256GB', price: 999.0, description: 'Điện thoại cấu hình mạnh nhất năm với camera AI xuất sắc.', category: 'Điện tử', image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.8, count: 1250), tag: _getRandomTag()),
  Product(id: 2, title: 'Laptop Gaming Pro 15 inch', price: 1499.99, description: 'Laptop chuyên game, card đồ họa rời siêu mạnh mẽ.', category: 'Điện tử', image: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.5, count: 540), tag: _getRandomTag()),
  Product(id: 3, title: 'Tai nghe Bluetooth không dây chống ồn', price: 120.5, description: 'Tai nghe chống ồn chủ động, pin sử dụng 30h liên tục.', category: 'Điện tử', image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.2, count: 4320), tag: _getRandomTag()),
  Product(id: 4, title: 'Đồng hồ thông minh Sport Fit', price: 199.0, description: 'Theo dõi nhịp tim, giấc ngủ, chống nước 5ATM.', category: 'Điện tử', image: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.6, count: 980), tag: _getRandomTag()),
  Product(id: 5, title: 'Máy ảnh Mirrorless 4K', price: 850.0, description: 'Máy ảnh kỹ thuật số gọn nhẹ, quay video 4K sắc nét.', category: 'Điện tử', image: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.9, count: 210), tag: _getRandomTag()),
  Product(id: 6, title: 'Loa Bluetooth Mini Bass Boost', price: 45.99, description: 'Loa di động âm bass cực đỉnh, chống nước IPX7.', category: 'Điện tử', image: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.1, count: 850), tag: _getRandomTag()),

  // Quần áo (Clothing)
  Product(id: 7, title: 'Áo thun Cotton cơ bản nam nữ', price: 15.0, description: 'Áo thun mặc mát mẻ, thấm hút mồ hôi tốt. Mặc ở nhà hay đi chơi đều hợp.', category: 'Quần áo', image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.7, count: 5000), tag: _getRandomTag()),
  Product(id: 8, title: 'Quần Jeans nam ống đứng retro', price: 35.5, description: 'Quần jeans dày dặn, kiểu dáng cổ điển không bao giờ lỗi mốt.', category: 'Quần áo', image: 'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.4, count: 1200), tag: _getRandomTag()),
  Product(id: 9, title: 'Áo khoác dệt kim len mùa thu', price: 28.0, description: 'Áo khoác len mềm mại, giữ ấm tốt, thời trang mùa thu đông.', category: 'Quần áo', image: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.9, count: 340), tag: _getRandomTag()),
  Product(id: 10, title: 'Đầm dạ hội nữ quý phái đỏ', price: 89.99, description: 'Đầm dự tiệc sang trọng, thiết kế ôm tôn dáng rực rỡ.', category: 'Quần áo', image: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.8, count: 110), tag: _getRandomTag()),
  Product(id: 11, title: 'Áo sơ mi lụa công sở nữ', price: 25.0, description: 'Sơ mi thanh lịch chất lụa trơn mát, thích hợp đi làm.', category: 'Quần áo', image: 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.5, count: 880), tag: _getRandomTag()),
  Product(id: 12, title: 'Áo Hoodie nỉ form rộng nam nữ', price: 22.0, description: 'Áo nỉ phong cách streetwear, ấm áp thoải mái.', category: 'Quần áo', image: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.6, count: 2100), tag: _getRandomTag()),

  // Giày dép (Shoes)
  Product(id: 13, title: 'Giày thể thao chạy bộ Ultra Run', price: 65.0, description: 'Giày chạy bộ đế êm, thoáng khí, bảo vệ chân tối ưu.', category: 'Giày dép', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.8, count: 3200), tag: _getRandomTag()),
  Product(id: 14, title: 'Giày Sneaker cổ cao nam tính', price: 55.0, description: 'Sneaker thiết kế basic nhưng cực kỳ cool ngầu.', category: 'Giày dép', image: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.7, count: 1500), tag: _getRandomTag()),
  Product(id: 15, title: 'Dép kẹp đi biển chống trượt', price: 9.99, description: 'Dép đi biển cao su mềm, dẻo dai chống trượt.', category: 'Giày dép', image: 'https://images.unsplash.com/photo-1603487742131-4160ec999306?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.2, count: 500), tag: _getRandomTag()),
  Product(id: 16, title: 'Giày sandal nữ gót vuông 5cm', price: 30.0, description: 'Sandal thời trang, tiểu thư, phối váy cực kỳ đẹp.', category: 'Giày dép', image: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.9, count: 680), tag: _getRandomTag()),
  Product(id: 17, title: 'Giày Da Nam cao cấp Oxford công sở', price: 110.0, description: 'Giày da thật 100%, lịch lãm, đẳng cấp doanh nhân.', category: 'Giày dép', image: 'https://images.unsplash.com/photo-1614252209808-8e811c039ab5?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.8, count: 240), tag: _getRandomTag()),
  Product(id: 18, title: 'Giày Lười nữ Loafer da bóng', price: 40.0, description: 'Giày lười êm chân, phù hợp dạo phố.', category: 'Giày dép', image: 'https://images.unsplash.com/photo-1560343090-f0409e92791a?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.5, count: 420), tag: _getRandomTag()),

  // Phụ kiện (Accessories)
  Product(id: 19, title: 'Kính râm phân cực đi nắng', price: 18.0, description: 'Kính râm gọng kim loại xịn, mắt kính phân cực giảm lóa.', category: 'Phụ kiện', image: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.5, count: 1100), tag: _getRandomTag()),
  Product(id: 20, title: 'Dây chuyền Bạc S925 mặt trăng', price: 29.5, description: 'Mặt dây chuyền bạc thật, cực kỳ sáng bóng và thanh lịch.', category: 'Phụ kiện', image: 'https://images.unsplash.com/photo-1599643478514-4a4e06d9cc76?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.9, count: 890), tag: _getRandomTag()),
  Product(id: 21, title: 'Balo Laptop chống nước 15.6 inch', price: 45.0, description: 'Balo nhiều ngăn tiện dụng, chất liệu trượt nước hoàn toàn.', category: 'Phụ kiện', image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.8, count: 2300), tag: _getRandomTag()),
  Product(id: 22, title: 'Mũ lưỡi trai Cotton thêu chữ', price: 12.0, description: 'Mũ lưỡi trai phong cách năng động, điều chỉnh được vòng đầu.', category: 'Phụ kiện', image: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.4, count: 400), tag: _getRandomTag()),
  Product(id: 23, title: 'Túi xách da nữ chần bông sang trọng', price: 75.0, description: 'Túi da mềm, vân chần tinh tế, khóa vàng cực sang.', category: 'Phụ kiện', image: 'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.7, count: 650), tag: _getRandomTag()),
  Product(id: 24, title: 'Thắt lưng Nam nguyên miếng da bò lõi', price: 28.0, description: 'Khóa tự động hợp kim. Da bò thật bền bỉ.', category: 'Phụ kiện', image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.6, count: 1800), tag: _getRandomTag()),

  // Gia dụng (Home Categories)
  Product(id: 25, title: 'Nồi chiên không dầu điện tử 5L', price: 85.0, description: 'Nồi chiên cảm ứng tiện lợi, bảo vệ sức khỏe gia đình.', category: 'Gia dụng', image: 'https://images.unsplash.com/photo-1626806819282-2c1dc01a5e0c?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.8, count: 3200), tag: _getRandomTag()),
  Product(id: 26, title: 'Máy ép chậm hoa quả củ quả nguyên trái', price: 120.0, description: 'Ép nguyên quả táo không cần cắt nhỏ, giữ trọn vẹn Vitamin.', category: 'Gia dụng', image: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.7, count: 450), tag: _getRandomTag()),
  Product(id: 27, title: 'Robot hút bụi lau nhà thông minh AI', price: 350.0, description: 'Tự động vượt chướng ngại vật, tự động giặt giẻ sấy khô.', category: 'Gia dụng', image: 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.9, count: 120), tag: _getRandomTag()),
  Product(id: 28, title: 'Bộ chăn ga gối nệm Cotton Lụa Cao cấp', price: 99.0, description: 'Mát lịm cực sướng, ngủ sâu giấc với chất lụa Tencel.', category: 'Gia dụng', image: 'https://images.unsplash.com/photo-1522771731478-4424ee712c98?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.8, count: 850), tag: _getRandomTag()),
  Product(id: 29, title: 'Đèn bàn học chống cận thị LED', price: 25.0, description: 'Đèn LED ánh sáng vàng bảo vệ mắt.', category: 'Gia dụng', image: 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.6, count: 2100), tag: _getRandomTag()),
  Product(id: 30, title: 'Máy sấy tóc chuyên nghiệp công suất lớn', price: 35.0, description: 'Máy sấy tạo kiểu tóc mượt không quéo.', category: 'Gia dụng', image: 'https://images.unsplash.com/photo-1522337660859-02fbefca4702?q=80&w=640&auto=format&fit=crop', rating: const ProductRating(rate: 4.7, count: 650), tag: _getRandomTag()),
];
