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

I decided to go with the approach of an HStack of two LazyVStacks instead of the Layout protocol since the Layout protocol computes sizes and other subview data without the subview necessarily being on screen (no lazy loading). 

The two LazyVStack approach still has a small issue though since the two lazy containers are independent of each other, and can't synchronize their height estimation, leading to a "push effect" as you scroll up where one column's contents get pushed down.

## TODO
- Improve memory performance with image hide on disappear
- Better toolbar button in iOS 18
