# Phia Onsite Demo


### Assumptions


#### Editorial (Primary) Card
- For the horizontal products scroll. I assumed that each product frame should have the same width and height, while the image fills the frame.
- Based on the Figma, I gathered that the editorial's primary photo should have variable height.
- I applied the verified checkmark to every user handle. Figma screens showed checkmark for select brands, but there was no way of making that distinction via the API.

#### Outfit (Primary) Card
- Since it uses a horizontal paging scroll view in the Figma, I combined the outfit `imgUrl` and items of products array's `imgUrl` and placed it in the scroll view's content. So the outfit image comes first, then its products right after.

#### Outfit (Secondary) Card
- The single outfit photo is just the outfit image with each payload.

#### Editorial (Secondary) Card
- The 3 product images on the right side are equal height (dynamic based on primary editorial image) but fixed width.

#### Masonry Grid
- I use the estimated height of each feed item type as a heursitic to place the feed item into the appropriate column.

### Masonry Grid - Architecture

At first, I decided to go with the approach of an HStack of two LazyVStacks instead of the Layout protocol since I was worried that the Layout protocol computes sizes and other subview data without the subview necessarily being on screen (no lazy loading). 

But after much testing, I realized that the two LazyVStack approach still has a small issue though since the two lazy containers are independent of each other, and can't synchronize their off-screen height estimation, leading to a "push and stutter effect" as you scroll up where one column's contents get pushed down. This was midly frequent, but very disturbing when it happened.

Then I decided to try the Layout protocol approach. No matter what, I knew that the images had to be deallocated whenever that image moved off-screen. Because the main bottleneck in terms of performance and memory was images.

The UIImage was stored in our custom async image's @State property which meant it would persist throughout the view's life, this also meant that `onDisappear` wouldn't work since it's only triggered when a view was removed from the hierarchy which wasn't the case in the `Layout` protocol implementation. Then I found `onScrollVisibilityChange`, allowing me to remove the image from the cell's state whenever its scroll visibility changed. This would ensure that only images that need to be displayed are ever rendered.

Another problem arose, UImage's internals cache the images that were previously loaded in memory + some images were being decoded into full resolution unnecessarily. So instead of creating a UIImage directly from a Data buffer, I went down to CGImage to speicify the caching rule, and downsampling rule so that we'd only decode the image into the necessary pixel buffer for the image frame.

The downsampling amount is determined by the `maxPixelSize` passed into the async images, which allows us to constrain the number of pixels in the largest edge of the image. This way we have smaller memory buffers for brand logos (like Phia), and products nested within views like Outfit or Editorial.

## TODO
- Better toolbar button in iOS 18
