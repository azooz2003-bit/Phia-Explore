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

### Editorial (Secondary) Card
- The 3 product images on the right side are equal height (dynamic based on primary editorial image) but fixed width.

## TODO
- Image caching for all images
- User defaults bookmark tracking
- Improved error messaging in async images
- Paging indicator complete logic
- Handle nonexistent img url cases gracefully

