# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Item.create([
    {
        name: "Samsung Galaxy Note 10",
        description: "Es tan genial como el Galaxy Note 10 Plus, pero es más barato y se siente mejor en tu mano y bolsillo",
        image_url: "https://test-e-commerce.s3.us-west-2.amazonaws.com/cel_image/cel_0.jpeg",
        price: 100
    },
    {
        name: "Samsung Galaxy Note 10 Plus",
        description: "Es el mejor celular Samsung en este momento y el más completo que puedes comprar, pero no significa que sea un celular perfecto. Este es nuestro análisis con lo bueno y lo malo.",
        image_url: "https://test-e-commerce.s3.us-west-2.amazonaws.com/cel_image/cel_1.jpeg",
        price: 250
    },
    {
        name: "Galaxy S10 Plus",
        description: "Es un celular con hasta 12GB de RAM, 1.5TB de almacenamiento, una gran batería y cámaras versátiles, características que lo hacen un ganador, a pesar de ser perfecto.",
        image_url: "https://test-e-commerce.s3.us-west-2.amazonaws.com/cel_image/cel_2.jpg",
        price: 300
    },
    {
        name: "OnePlus 7 Pro",
        description: "Es un celular con un diseño hermoso, un desempeño ejemplar y una carga muy rápida, pero también es el OnePlus más caro hasta la fecha (que no ha sido edición limitada).",
        image_url: "https://test-e-commerce.s3-us-west-2.amazonaws.com/cel_image/cel_3.jpeg",
        price: 320
    },
    {
        name: "Samsung Galaxy S10",
        description: "El teléfono que podríamos llamar estándar de la familia Galaxy S10 no sólo hereda lo mejor del teléfono más caro, sino que además tiene un tamaño ideal, una pantalla elegante y un funcionamiento de lujo.",
        image_url: "https://test-e-commerce.s3-us-west-2.amazonaws.com/cel_image/cel_4.jpg",
        price: 340
    },
    {
        name: "Huawei P30 Pro",
        description: "Es un teléfono muy completo que sobresale principalmente por su cámara que ofrece zoom óptico 5X (algo que es muy difícil de encontrar en el mercado) y una cámara que sorprende, especialmente con poca luz.",
        image_url: "https://test-e-commerce.s3-us-west-2.amazonaws.com/cel_image/cel_5.jpg",
        price: 350
    },
    {
        name: "Pixel 4 XL",
        description: "Es un buen celular que sobresale principalmente por sus excelentes cámaras traseras, pero por su precio es posible que encuentres otras mejores opciones, si lo primordial para ti no es tener la excelente cámara de Google.",
        image_url: "https://test-e-commerce.s3-us-west-2.amazonaws.com/cel_image/cel_6.jpg",
        price: 410
    },
    {
        name: "El OnePlus 7T",
        description: "Es un excelente celular que brinda una pantalla de 90Hz por menos y con algunas mejoras frente al OnePlus 7 Pro.",
        image_url: "https://test-e-commerce.s3-us-west-2.amazonaws.com/cel_image/cel_7.jpeg",
        price: 400
    },
    {
        name: "Samsung Galaxy S10E",
        description: "El nuevo teléfono de Samsung más barato tiene el mismo procesador de sus hermanos mayores, una pantalla más pequeña y algunos detalles que le hacen inferior, aunque las diferencias no son tan grandes a primera vista.",
        image_url: "https://test-e-commerce.s3-us-west-2.amazonaws.com/cel_image/cel_8.jpeg",
        price: 230
    },
    {
        name: "Xiaomi Mi 9T Pro",
        description: "El celular del fabricante chino Xiaomi tiene una gran batería, un procesador último modelo, un diseño atrevido y cámaras competitivas a un precio que no te romperá el bolsillo.",
        image_url: "https://test-e-commerce.s3-us-west-2.amazonaws.com/cel_image/cel_9.jpeg",
        price: 210
    }
    ])
