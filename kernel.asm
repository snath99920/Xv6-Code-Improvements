
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 71 10 80       	push   $0x80107120
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 95 43 00 00       	call   801043f0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 71 10 80       	push   $0x80107127
80100097:	50                   	push   %eax
80100098:	e8 23 42 00 00       	call   801042c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 47 44 00 00       	call   80104530 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 89 44 00 00       	call   801045f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 41 00 00       	call   80104300 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 71 10 80       	push   $0x8010712e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ed 41 00 00       	call   801043a0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 71 10 80       	push   $0x8010713f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ac 41 00 00       	call   801043a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 41 00 00       	call   80104360 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 20 43 00 00       	call   80104530 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 8f 43 00 00       	jmp    801045f0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 71 10 80       	push   $0x80107146
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 9f 42 00 00       	call   80104530 <acquire>
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 66 3b 00 00       	call   80103e30 <sleep>
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
801002db:	e8 70 35 00 00       	call   80103850 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 fc 42 00 00       	call   801045f0 <release>
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
801002fc:	83 c4 10             	add    $0x10,%esp
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
80100329:	83 c6 01             	add    $0x1,%esi
8010032c:	83 eb 01             	sub    $0x1,%ebx
8010032f:	83 f8 0a             	cmp    $0xa,%eax
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
80100335:	74 43                	je     8010037a <consoleread+0x10a>
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 9e 42 00 00       	call   801045f0 <release>
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
80100398:	fa                   	cli    
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 71 10 80       	push   $0x8010714d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
801003c5:	c7 04 24 9b 7a 10 80 	movl   $0x80107a9b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 33 40 00 00       	call   80104410 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 71 10 80       	push   $0x80107161
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 f1 58 00 00       	call   80105d30 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
80100457:	0f b6 c0             	movzbl %al,%eax
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
8010046d:	09 fb                	or     %edi,%ebx
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 3f 58 00 00       	call   80105d30 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 58 00 00       	call   80105d30 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 58 00 00       	call   80105d30 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
80100517:	83 eb 50             	sub    $0x50,%ebx
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 c7 41 00 00       	call   801046f0 <memmove>
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 fa 40 00 00       	call   80104640 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 71 10 80       	push   $0x80107165
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
8010058b:	85 c9                	test   %ecx,%ecx
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 71 10 80 	movzbl -0x7fef8e70(%edx),%edx
801005b8:	85 c0                	test   %eax,%eax
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 10 3f 00 00       	call   80104530 <acquire>
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 a4 3f 00 00       	call   801045f0 <release>
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010066e:	85 c0                	test   %eax,%eax
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
8010068c:	31 db                	xor    %ebx,%ebx
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801006a0:	0f b6 16             	movzbl (%esi),%edx
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
801006fe:	0f b6 06             	movzbl (%esi),%eax
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 cc 3e 00 00       	call   801045f0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
80100787:	0f be 02             	movsbl (%edx),%eax
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
801007d0:	ba 78 71 10 80       	mov    $0x80107178,%edx
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 3b 3d 00 00       	call   80104530 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 71 10 80       	push   $0x8010717f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
80100816:	31 f6                	xor    %esi,%esi
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 08 3d 00 00       	call   80104530 <acquire>
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 63 3d 00 00       	call   801045f0 <release>
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
801008c5:	83 ff 0d             	cmp    $0xd,%edi
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
80100909:	83 ec 0c             	sub    $0xc,%esp
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 d5 36 00 00       	call   80103ff0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
80100997:	e9 34 37 00 00       	jmp    801040d0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
801009c6:	68 88 71 10 80       	push   $0x80107188
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 1b 3a 00 00       	call   801043f0 <initlock>
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
80100a1c:	e8 2f 2e 00 00       	call   80103850 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
80100a94:	e8 e7 63 00 00       	call   80106e80 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
80100aa3:	31 ff                	xor    %edi,%edi
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 96 02 00 00    	je     80100d55 <exec+0x345>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 a5 61 00 00       	call   80106ca0 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 b3 60 00 00       	call   80106be0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 89 62 00 00       	call   80106e00 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 f1 60 00 00       	call   80106ca0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 3a 62 00 00       	call   80106e00 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 a1 71 10 80       	push   $0x801071a1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 15 63 00 00       	call   80106f20 <clearpteu>
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 22 3c 00 00       	call   80104860 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 0f 3c 00 00       	call   80104860 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 1e 64 00 00       	call   80107080 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
80100c77:	83 c7 01             	add    $0x1,%edi
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
80100cb1:	29 c1                	sub    %eax,%ecx
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
80100cc7:	e8 b4 63 00 00       	call   80107080 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 11 3b 00 00       	call   80104820 <safestrcpy>
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
80100d1d:	89 31                	mov    %esi,(%ecx)
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
80100d31:	c7 81 88 00 00 00 3c 	movl   $0x3c,0x88(%ecx)
80100d38:	00 00 00 
80100d3b:	89 0c 24             	mov    %ecx,(%esp)
80100d3e:	e8 0d 5d 00 00       	call   80106a50 <switchuvm>
80100d43:	89 3c 24             	mov    %edi,(%esp)
80100d46:	e8 b5 60 00 00       	call   80106e00 <freevm>
80100d4b:	83 c4 10             	add    $0x10,%esp
80100d4e:	31 c0                	xor    %eax,%eax
80100d50:	e9 27 fd ff ff       	jmp    80100a7c <exec+0x6c>
80100d55:	be 00 20 00 00       	mov    $0x2000,%esi
80100d5a:	e9 32 fe ff ff       	jmp    80100b91 <exec+0x181>
80100d5f:	90                   	nop

80100d60 <fileinit>:
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
80100d66:	68 ad 71 10 80       	push   $0x801071ad
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 7b 36 00 00       	call   801043f0 <initlock>
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100d89:	83 ec 10             	sub    $0x10,%esp
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 9a 37 00 00       	call   80104530 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
80100db2:	83 ec 0c             	sub    $0xc,%esp
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 2a 38 00 00       	call   801045f0 <release>
80100dc6:	89 d8                	mov    %ebx,%eax
80100dc8:	83 c4 10             	add    $0x10,%esp
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
80100dd0:	83 ec 0c             	sub    $0xc,%esp
80100dd3:	31 db                	xor    %ebx,%ebx
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 11 38 00 00       	call   801045f0 <release>
80100ddf:	89 d8                	mov    %ebx,%eax
80100de1:	83 c4 10             	add    $0x10,%esp
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 2c 37 00 00       	call   80104530 <acquire>
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
80100e0e:	83 c0 01             	add    $0x1,%eax
80100e11:	83 ec 0c             	sub    $0xc,%esp
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 cf 37 00 00       	call   801045f0 <release>
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 b4 71 10 80       	push   $0x801071b4
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 da 36 00 00       	call   80104530 <acquire>
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
80100e7c:	e9 6f 37 00 00       	jmp    801045f0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
80100e8e:	83 ec 0c             	sub    $0xc,%esp
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ea8:	e8 43 37 00 00       	call   801045f0 <release>
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
80100ef0:	83 c4 10             	add    $0x10,%esp
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 bc 71 10 80       	push   $0x801071bc
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
80100fb3:	83 c4 10             	add    $0x10,%esp
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 c6 71 10 80       	push   $0x801071c6
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101029:	31 ff                	xor    %edi,%edi
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101038:	01 46 14             	add    %eax,0x14(%esi)
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
8010105c:	01 df                	add    %ebx,%edi
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 cf 71 10 80       	push   $0x801071cf
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 d5 71 10 80       	push   $0x801071d5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
8010112a:	89 d9                	mov    %ebx,%ecx
8010112c:	c1 fb 03             	sar    $0x3,%ebx
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
80101140:	d3 e2                	shl    %cl,%edx
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 df 71 10 80       	push   $0x801071df
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
80101189:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011be:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
801011d0:	89 c1                	mov    %eax,%ecx
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 f2 71 10 80       	push   $0x801071f2
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101233:	83 ec 0c             	sub    $0xc,%esp
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 d6 33 00 00       	call   80104640 <memset>
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
80101298:	31 f6                	xor    %esi,%esi
8010129a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801012a5:	68 e0 09 11 80       	push   $0x801109e0
801012aa:	e8 81 32 00 00       	call   80104530 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
801012f4:	83 ec 0c             	sub    $0xc,%esp
801012f7:	89 3e                	mov    %edi,(%esi)
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010130a:	68 e0 09 11 80       	push   $0x801109e0
8010130f:	e8 dc 32 00 00       	call   801045f0 <release>
80101314:	83 c4 10             	add    $0x10,%esp
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
8010132d:	83 ec 0c             	sub    $0xc,%esp
80101330:	83 c1 01             	add    $0x1,%ecx
80101333:	89 de                	mov    %ebx,%esi
80101335:	68 e0 09 11 80       	push   $0x801109e0
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
8010133d:	e8 ae 32 00 00       	call   801045f0 <release>
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 08 72 10 80       	push   $0x80107208
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
801013b1:	89 c7                	mov    %eax,%edi
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013c6:	83 ec 0c             	sub    $0xc,%esp
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013fd:	89 c3                	mov    %eax,%ebx
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 18 72 10 80       	push   $0x80107218
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 8a 32 00 00       	call   801046f0 <memmove>
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
8010148c:	68 2b 72 10 80       	push   $0x8010722b
80101491:	68 e0 09 11 80       	push   $0x801109e0
80101496:	e8 55 2f 00 00       	call   801043f0 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 32 72 10 80       	push   $0x80107232
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 0c 2e 00 00       	call   801042c0 <initsleeplock>
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 c0 09 11 80       	push   $0x801109c0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
801014cf:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014d5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014db:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014e1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014e7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014ed:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014f3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014f9:	68 98 72 10 80       	push   $0x80107298
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
80101519:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101540:	83 ec 0c             	sub    $0xc,%esp
80101543:	83 c3 01             	add    $0x1,%ebx
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
8010156e:	89 d8                	mov    %ebx,%eax
80101570:	83 c4 10             	add    $0x10,%esp
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 ad 30 00 00       	call   80104640 <memset>
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
801015ad:	83 c4 10             	add    $0x10,%esp
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 38 72 10 80       	push   $0x80107238
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
801015de:	83 c3 5c             	add    $0x5c,%ebx
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
801015fc:	83 c4 0c             	add    $0xc,%esp
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
80101609:	66 89 10             	mov    %dx,(%eax)
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
80101610:	83 c0 0c             	add    $0xc,%eax
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 ba 30 00 00       	call   801046f0 <memmove>
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010165a:	68 e0 09 11 80       	push   $0x801109e0
8010165f:	e8 cc 2e 00 00       	call   80104530 <acquire>
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
80101668:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010166f:	e8 7c 2f 00 00       	call   801045f0 <release>
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 59 2c 00 00       	call   80104300 <acquiresleep>
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
801016dc:	83 c4 0c             	add    $0xc,%esp
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
801016e9:	0f b7 10             	movzwl (%eax),%edx
801016ec:	83 c0 0c             	add    $0xc,%eax
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 d3 2f 00 00       	call   801046f0 <memmove>
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 50 72 10 80       	push   $0x80107250
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 4a 72 10 80       	push   $0x8010724a
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 28 2c 00 00       	call   801043a0 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
8010178f:	e9 cc 2b 00 00       	jmp    80104360 <releasesleep>
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 5f 72 10 80       	push   $0x8010725f
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 3b 2b 00 00       	call   80104300 <acquiresleep>
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 81 2b 00 00       	call   80104360 <releasesleep>
801017df:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017e6:	e8 45 2d 00 00       	call   80104530 <acquire>
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
80101800:	e9 eb 2d 00 00       	jmp    801045f0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 e0 09 11 80       	push   $0x801109e0
80101810:	e8 1b 2d 00 00       	call   80104530 <acquire>
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
80101818:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010181f:	e8 cc 2d 00 00       	call   801045f0 <release>
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
8010186d:	83 ec 0c             	sub    $0xc,%esp
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019dd:	89 c2                	mov    %eax,%edx
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
80101a00:	01 df                	add    %ebx,%edi
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
80101a05:	01 de                	add    %ebx,%esi
80101a07:	e8 e4 2c 00 00       	call   801046f0 <memmove>
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
80101a4f:	ff e0                	jmp    *%eax
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
80101ae0:	89 c7                	mov    %eax,%edi
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
80101b00:	01 de                	add    %ebx,%esi
80101b02:	50                   	push   %eax
80101b03:	e8 e8 2b 00 00       	call   801046f0 <memmove>
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6b:	83 ec 0c             	sub    $0xc,%esp
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 bd 2b 00 00       	call   80104760 <strncmp>
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 5e 2b 00 00       	call   80104760 <strncmp>
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c14:	31 c0                	xor    %eax,%eax
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 79 72 10 80       	push   $0x80107279
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 67 72 10 80       	push   $0x80107267
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
80101c79:	e8 d2 1b 00 00       	call   80103850 <myproc>
80101c7e:	83 ec 0c             	sub    $0xc,%esp
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
80101c84:	68 e0 09 11 80       	push   $0x801109e0
80101c89:	e8 a2 28 00 00       	call   80104530 <acquire>
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
80101c92:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c99:	e8 52 29 00 00       	call   801045f0 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ca8:	83 c3 01             	add    $0x1,%ebx
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
80101cd4:	83 c2 01             	add    $0x1,%edx
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 f6 29 00 00       	call   801046f0 <memmove>
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cfd:	83 c4 10             	add    $0x10,%esp
80101d00:	89 d3                	mov    %edx,%ebx
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101d10:	83 c3 01             	add    $0x1,%ebx
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 63 29 00 00       	call   801046f0 <memmove>
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
80101dc9:	89 34 24             	mov    %esi,(%esp)
80101dcc:	31 f6                	xor    %esi,%esi
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
80101dd3:	83 c4 10             	add    $0x10,%esp
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
80101dff:	83 c4 10             	add    $0x10,%esp
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
80101e10:	31 f6                	xor    %esi,%esi
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 3e 29 00 00       	call   801047c0 <strncpy>
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
80101e9b:	31 c0                	xor    %eax,%eax
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 88 72 10 80       	push   $0x80107288
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 82 78 10 80       	push   $0x80107882
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:
80101ee0:	55                   	push   %ebp
80101ee1:	31 d2                	xor    %edx,%edx
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:
80101f00:	55                   	push   %ebp
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
80101f06:	89 e5                	mov    %esp,%ebp
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0e:	5d                   	pop    %ebp
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fc5:	83 c6 5c             	add    $0x5c,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 f4 72 10 80       	push   $0x801072f4
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 eb 72 10 80       	push   $0x801072eb
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
80102006:	68 06 73 10 80       	push   $0x80107306
8010200b:	68 80 a5 10 80       	push   $0x8010a580
80102010:	e8 db 23 00 00       	call   801043f0 <initlock>
80102015:	58                   	pop    %eax
80102016:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
8010205a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102061:	00 00 00 
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
80102089:	68 80 a5 10 80       	push   $0x8010a580
8010208e:	e8 9d 24 00 00       	call   80104530 <acquire>
80102093:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
801020a0:	8b 43 58             	mov    0x58(%ebx),%eax
801020a3:	a3 64 a5 10 80       	mov    %eax,0x8010a564
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
801020d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
801020e6:	83 ec 0c             	sub    $0xc,%esp
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
801020f0:	53                   	push   %ebx
801020f1:	e8 fa 1e 00 00       	call   80103ff0 <wakeup>
801020f6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 80 a5 10 80       	push   $0x8010a580
8010210f:	e8 dc 24 00 00       	call   801045f0 <release>
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 6d 22 00 00       	call   801043a0 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 80 a5 10 80       	push   $0x8010a580
80102168:	e8 c3 23 00 00       	call   80104530 <acquire>
8010216d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102173:	83 c4 10             	add    $0x10,%esp
80102176:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 58             	mov    0x58(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 58             	add    $0x58,%edx
80102194:	89 1a                	mov    %ebx,(%edx)
80102196:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 80 a5 10 80       	push   $0x8010a580
801021b8:	53                   	push   %ebx
801021b9:	e8 72 1c 00 00       	call   80103e30 <sleep>
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
801021cb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
801021d6:	e9 15 24 00 00       	jmp    801045f0 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021f0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 20 73 10 80       	push   $0x80107320
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 0a 73 10 80       	push   $0x8010730a
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 35 73 10 80       	push   $0x80107335
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
80102220:	55                   	push   %ebp
80102221:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102228:	00 c0 fe 
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
80102239:	a1 34 26 11 80       	mov    0x80112634,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80102247:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010224d:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80102254:	c1 eb 10             	shr    $0x10,%ebx
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
8010225a:	0f b6 db             	movzbl %bl,%ebx
8010225d:	c1 e8 18             	shr    $0x18,%eax
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 54 73 10 80       	push   $0x80107354
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102290:	89 11                	mov    %edx,(%ecx)
80102292:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
801022ac:	39 d8                	cmp    %ebx,%eax
801022ae:	89 31                	mov    %esi,(%ecx)
801022b0:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:
801022d0:	55                   	push   %ebp
801022d1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
801022e3:	89 01                	mov    %eax,(%ecx)
801022e5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022eb:	83 c0 01             	add    $0x1,%eax
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801022f4:	89 01                	mov    %eax,(%ecx)
801022f6:	a1 34 26 11 80       	mov    0x80112634,%eax
801022fb:	c1 e2 18             	shl    $0x18,%edx
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb a8 58 11 80    	cmp    $0x801158a8,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 f9 22 00 00       	call   80104640 <memset>
80102347:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
80102354:	a1 78 26 11 80       	mov    0x80112678,%eax
80102359:	89 03                	mov    %eax,(%ebx)
8010235b:	a1 74 26 11 80       	mov    0x80112674,%eax
80102360:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
80102370:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
8010237b:	e9 70 22 00 00       	jmp    801045f0 <release>
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 40 26 11 80       	push   $0x80112640
80102388:	e8 a3 21 00 00       	call   80104530 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 86 73 10 80       	push   $0x80107386
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 8c 73 10 80       	push   $0x8010738c
80102400:	68 40 26 11 80       	push   $0x80112640
80102405:	e8 e6 1f 00 00       	call   801043f0 <initlock>
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
8010240d:	83 c4 10             	add    $0x10,%esp
80102410:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102417:	00 00 00 
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
801024a4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024ab:	00 00 00 
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
801024c0:	a1 74 26 11 80       	mov    0x80112674,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
801024c9:	a1 78 26 11 80       	mov    0x80112678,%eax
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 78 26 11 80    	mov    %edx,0x80112678
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
801024ee:	68 40 26 11 80       	push   $0x80112640
801024f3:	e8 38 20 00 00       	call   80104530 <acquire>
801024f8:	a1 78 26 11 80       	mov    0x80112678,%eax
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 40 26 11 80       	push   $0x80112640
80102521:	e8 ca 20 00 00       	call   801045f0 <release>
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102529:	83 c4 10             	add    $0x10,%esp
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
8010256a:	83 c8 80             	or     $0xffffff80,%eax
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
80102570:	0f b6 d0             	movzbl %al,%edx
80102573:	0f b6 82 c0 74 10 80 	movzbl -0x7fef8b40(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
8010257c:	0f b6 82 c0 73 10 80 	movzbl -0x7fef8c40(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
80102585:	89 c8                	mov    %ecx,%eax
80102587:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
8010258d:	83 e0 03             	and    $0x3,%eax
80102590:	83 e1 08             	and    $0x8,%ecx
80102593:	8b 04 85 a0 73 10 80 	mov    -0x7fef8c60(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
801025a8:	83 e8 20             	sub    $0x20,%eax
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
801025b8:	0f b6 82 c0 74 10 80 	movzbl -0x7fef8b40(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
801025c9:	31 c0                	xor    %eax,%eax
801025cb:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025d8:	83 c9 40             	or     $0x40,%ecx
801025db:	31 c0                	xor    %eax,%eax
801025dd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
801025ee:	5b                   	pop    %ebx
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
80102630:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
80102657:	8b 50 20             	mov    0x20(%eax),%edx
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
80102664:	8b 50 20             	mov    0x20(%eax),%edx
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
80102671:	8b 50 20             	mov    0x20(%eax),%edx
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
80102705:	8b 40 20             	mov    0x20(%eax),%eax
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:
80102730:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:
80102750:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
80102766:	8b 40 20             	mov    0x20(%eax),%eax
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:
80102780:	55                   	push   %ebp
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
801027a0:	31 c0                	xor    %eax,%eax
801027a2:	c1 e3 18             	shl    $0x18,%ebx
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
801027ab:	89 c8                	mov    %ecx,%eax
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
801027b0:	c1 e8 04             	shr    $0x4,%eax
801027b3:	89 da                	mov    %ebx,%edx
801027b5:	80 cd 06             	or     $0x6,%ch
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
801027be:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
80102807:	8b 40 20             	mov    0x20(%eax),%eax
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
80102927:	83 ec 04             	sub    $0x4,%esp
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 54 1d 00 00       	call   80104690 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
80102a00:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
80102a14:	31 db                	xor    %ebx,%ebx
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a20:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102a44:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a4a:	83 c3 01             	add    $0x1,%ebx
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
80102a54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 87 1c 00 00       	call   801046f0 <memmove>
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102aae:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
80102ab9:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
80102abf:	83 c4 10             	add    $0x10,%esp
80102ac2:	89 c6                	mov    %eax,%esi
80102ac4:	85 db                	test   %ebx,%ebx
80102ac6:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
80102ad0:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102ad6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b0a:	68 c0 75 10 80       	push   $0x801075c0
80102b0f:	68 80 26 11 80       	push   $0x80112680
80102b14:	e8 d7 18 00 00       	call   801043f0 <initlock>
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102b2b:	59                   	pop    %ecx
80102b2c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
80102b32:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
80102b38:	a3 b4 26 11 80       	mov    %eax,0x801126b4
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
80102b45:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
80102b4d:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
80102b7f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b86:	00 00 00 
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
80102ba6:	68 80 26 11 80       	push   $0x80112680
80102bab:	e8 80 19 00 00       	call   80104530 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 80 26 11 80       	push   $0x80112680
80102bc0:	68 80 26 11 80       	push   $0x80112680
80102bc5:	e8 66 12 00 00       	call   80103e30 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
80102bcd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
80102bd6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102bdb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
80102bef:	83 ec 0c             	sub    $0xc,%esp
80102bf2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
80102bf7:	68 80 26 11 80       	push   $0x80112680
80102bfc:	e8 ef 19 00 00       	call   801045f0 <release>
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
80102c19:	68 80 26 11 80       	push   $0x80112680
80102c1e:	e8 0d 19 00 00       	call   80104530 <acquire>
80102c23:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c28:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102c34:	85 f6                	test   %esi,%esi
80102c36:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
80102c4a:	83 ec 0c             	sub    $0xc,%esp
80102c4d:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c54:	00 00 00 
80102c57:	68 80 26 11 80       	push   $0x80112680
80102c5c:	e8 8f 19 00 00       	call   801045f0 <release>
80102c61:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
80102c72:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c96:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c9c:	83 c3 01             	add    $0x1,%ebx
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
80102ca6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 35 1a 00 00       	call   801046f0 <memmove>
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
80102ce8:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cef:	00 00 00 
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 80 26 11 80       	push   $0x80112680
80102cff:	e8 2c 18 00 00       	call   80104530 <acquire>
80102d04:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d0b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d12:	00 00 00 
80102d15:	e8 d6 12 00 00       	call   80103ff0 <wakeup>
80102d1a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d21:	e8 ca 18 00 00       	call   801045f0 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 80 26 11 80       	push   $0x80112680
80102d40:	e8 ab 12 00 00       	call   80103ff0 <wakeup>
80102d45:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d4c:	e8 9f 18 00 00       	call   801045f0 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 c4 75 10 80       	push   $0x801075c4
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
80102d77:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
80102d99:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 80 26 11 80       	push   $0x80112680
80102dae:	e8 7d 17 00 00       	call   80104530 <acquire>
80102db3:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
80102dc4:	31 c0                	xor    %eax,%eax
80102dc6:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
80102de0:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 c8 26 11 80       	mov    %eax,0x801126c8
80102def:	83 0b 04             	orl    $0x4,(%ebx)
80102df2:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
80102dfd:	e9 ee 17 00 00       	jmp    801045f0 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e08:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 d3 75 10 80       	push   $0x801075d3
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 e9 75 10 80       	push   $0x801075e9
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
80102e47:	e8 e4 09 00 00       	call   80103830 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 dd 09 00 00       	call   80103830 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 04 76 10 80       	push   $0x80107604
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
80102e62:	e8 a9 2a 00 00       	call   80105910 <idtinit>
80102e67:	e8 44 09 00 00       	call   801037b0 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
80102e7a:	e8 91 0c 00 00       	call   80103b10 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
80102e86:	e8 a5 3b 00 00       	call   80106a30 <switchkvm>
80102e8b:	e8 10 3b 00 00       	call   801069a0 <seginit>
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 a8 58 11 80       	push   $0x801158a8
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
80102ec1:	e8 3a 40 00 00       	call   80106f00 <kvmalloc>
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
80102ed0:	e8 cb 3a 00 00       	call   801069a0 <seginit>
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
80102ee4:	e8 87 2d 00 00       	call   80105c70 <uartinit>
80102ee9:	e8 52 08 00 00       	call   80103740 <pinit>
80102eee:	e8 9d 29 00 00       	call   80105890 <tvinit>
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 8c a4 10 80       	push   $0x8010a48c
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 d7 17 00 00       	call   801046f0 <memmove>
80102f19:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 80 27 11 80       	add    $0x80112780,%eax
80102f2b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102f40:	e8 6b 08 00 00       	call   801037b0 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f64:	90 10 00 
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
80102f8a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
80102fb5:	e8 c6 08 00 00       	call   80103880 <userinit>
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102fcb:	53                   	push   %ebx
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
80102fcf:	83 ec 0c             	sub    $0xc,%esp
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 18 76 10 80       	push   $0x80107618
80102ff3:	56                   	push   %esi
80102ff4:	e8 97 16 00 00       	call   80104690 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302b:	31 f6                	xor    %esi,%esi
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 35 76 10 80       	push   $0x80107635
801030b1:	56                   	push   %esi
801030b2:	e8 d9 15 00 00       	call   80104690 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 7c 26 11 80       	mov    %eax,0x8011267c
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 5c 76 10 80 	jmp    *-0x7fef89a4(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103150:	83 c0 08             	add    $0x8,%eax
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
80103179:	83 c8 01             	or     $0x1,%eax
8010317c:	ee                   	out    %al,(%dx)
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
80103188:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
801031a6:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
801031ac:	83 c0 14             	add    $0x14,%eax
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031bc:	83 c0 08             	add    $0x8,%eax
801031bf:	88 15 60 27 11 80    	mov    %dl,0x80112760
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
801031df:	85 c0                	test   %eax,%eax
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 1d 76 10 80       	push   $0x8010761d
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 3c 76 10 80       	push   $0x8010763c
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
801032bf:	8b 06                	mov    (%esi),%eax
801032c1:	83 c4 10             	add    $0x10,%esp
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032d0:	83 ec 08             	sub    $0x8,%esp
801032d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032da:	00 00 00 
801032dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032e4:	00 00 00 
801032e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032ee:	00 00 00 
801032f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032f8:	00 00 00 
801032fb:	68 70 76 10 80       	push   $0x80107670
80103300:	50                   	push   %eax
80103301:	e8 ea 10 00 00       	call   801043f0 <initlock>
80103306:	8b 03                	mov    (%ebx),%eax
80103308:	83 c4 10             	add    $0x10,%esp
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333e:	31 c0                	xor    %eax,%eax
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 cc 11 00 00       	call   80104530 <acquire>
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
8010336b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
80103374:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010337b:	00 00 00 
8010337e:	50                   	push   %eax
8010337f:	e8 6c 0c 00 00       	call   80103ff0 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
80103387:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
801033a4:	e9 47 12 00 00       	jmp    801045f0 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
801033b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c0:	00 00 00 
801033c3:	50                   	push   %eax
801033c4:	e8 27 0c 00 00       	call   80103ff0 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 17 12 00 00       	call   801045f0 <release>
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033fc:	53                   	push   %ebx
801033fd:	e8 2e 11 00 00       	call   80104530 <acquire>
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103419:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103428:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
80103438:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
80103442:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 97 0b 00 00       	call   80103ff0 <wakeup>
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 ce 09 00 00       	call   80103e30 <sleep>
80103462:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103468:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
8010347a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 c7 03 00 00       	call   80103850 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 57 11 00 00       	call   801045f0 <release>
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801034cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
801034d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 08 0b 00 00       	call   80103ff0 <wakeup>
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 00 11 00 00       	call   801045f0 <release>
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010350f:	56                   	push   %esi
80103510:	e8 1b 10 00 00       	call   80104530 <acquire>
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010351e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
80103534:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 e6 08 00 00       	call   80103e30 <sleep>
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103553:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
80103569:	e8 e2 02 00 00       	call   80103850 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
80103575:	83 ec 0c             	sub    $0xc,%esp
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010357d:	56                   	push   %esi
8010357e:	e8 6d 10 00 00       	call   801045f0 <release>
80103583:	83 c4 10             	add    $0x10,%esp
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
801035cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 14 0a 00 00       	call   80103ff0 <wakeup>
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 0c 10 00 00       	call   801045f0 <release>
801035e4:	83 c4 10             	add    $0x10,%esp
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <allocproc>:
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	53                   	push   %ebx
80103604:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103609:	83 ec 10             	sub    $0x10,%esp
8010360c:	68 20 2d 11 80       	push   $0x80112d20
80103611:	e8 1a 0f 00 00       	call   80104530 <acquire>
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	eb 17                	jmp    80103632 <allocproc+0x32>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103620:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103626:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
8010362c:	0f 83 96 00 00 00    	jae    801036c8 <allocproc+0xc8>
80103632:	8b 43 0c             	mov    0xc(%ebx),%eax
80103635:	85 c0                	test   %eax,%eax
80103637:	75 e7                	jne    80103620 <allocproc+0x20>
80103639:	a1 04 a0 10 80       	mov    0x8010a004,%eax
8010363e:	83 ec 0c             	sub    $0xc,%esp
80103641:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
80103648:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010364f:	00 00 00 
80103652:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103659:	00 00 00 
8010365c:	8d 50 01             	lea    0x1(%eax),%edx
8010365f:	89 43 10             	mov    %eax,0x10(%ebx)
80103662:	a1 a0 58 11 80       	mov    0x801158a0,%eax
80103667:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010366d:	89 43 7c             	mov    %eax,0x7c(%ebx)
80103670:	68 20 2d 11 80       	push   $0x80112d20
80103675:	e8 76 0f 00 00       	call   801045f0 <release>
8010367a:	e8 41 ee ff ff       	call   801024c0 <kalloc>
8010367f:	83 c4 10             	add    $0x10,%esp
80103682:	85 c0                	test   %eax,%eax
80103684:	89 43 08             	mov    %eax,0x8(%ebx)
80103687:	74 58                	je     801036e1 <allocproc+0xe1>
80103689:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
8010368f:	83 ec 04             	sub    $0x4,%esp
80103692:	05 9c 0f 00 00       	add    $0xf9c,%eax
80103697:	89 53 18             	mov    %edx,0x18(%ebx)
8010369a:	c7 40 14 82 58 10 80 	movl   $0x80105882,0x14(%eax)
801036a1:	89 43 1c             	mov    %eax,0x1c(%ebx)
801036a4:	6a 14                	push   $0x14
801036a6:	6a 00                	push   $0x0
801036a8:	50                   	push   %eax
801036a9:	e8 92 0f 00 00       	call   80104640 <memset>
801036ae:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036b1:	83 c4 10             	add    $0x10,%esp
801036b4:	c7 40 10 f0 36 10 80 	movl   $0x801036f0,0x10(%eax)
801036bb:	89 d8                	mov    %ebx,%eax
801036bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036c0:	c9                   	leave  
801036c1:	c3                   	ret    
801036c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	31 db                	xor    %ebx,%ebx
801036cd:	68 20 2d 11 80       	push   $0x80112d20
801036d2:	e8 19 0f 00 00       	call   801045f0 <release>
801036d7:	89 d8                	mov    %ebx,%eax
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036df:	c9                   	leave  
801036e0:	c3                   	ret    
801036e1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
801036e8:	31 db                	xor    %ebx,%ebx
801036ea:	eb cf                	jmp    801036bb <allocproc+0xbb>
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036f0 <forkret>:
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 14             	sub    $0x14,%esp
801036f6:	68 20 2d 11 80       	push   $0x80112d20
801036fb:	e8 f0 0e 00 00       	call   801045f0 <release>
80103700:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	85 c0                	test   %eax,%eax
8010370a:	75 04                	jne    80103710 <forkret+0x20>
8010370c:	c9                   	leave  
8010370d:	c3                   	ret    
8010370e:	66 90                	xchg   %ax,%ax
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010371a:	00 00 00 
8010371d:	6a 01                	push   $0x1
8010371f:	e8 5c dd ff ff       	call   80101480 <iinit>
80103724:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010372b:	e8 d0 f3 ff ff       	call   80102b00 <initlog>
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	c9                   	leave  
80103734:	c3                   	ret    
80103735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <pinit>:
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 10             	sub    $0x10,%esp
80103746:	68 75 76 10 80       	push   $0x80107675
8010374b:	68 20 2d 11 80       	push   $0x80112d20
80103750:	e8 9b 0c 00 00       	call   801043f0 <initlock>
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	c9                   	leave  
80103759:	c3                   	ret    
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103760 <runinc>:
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	83 ec 14             	sub    $0x14,%esp
80103766:	68 20 2d 11 80       	push   $0x80112d20
8010376b:	e8 c0 0d 00 00       	call   80104530 <acquire>
80103770:	83 c4 10             	add    $0x10,%esp
80103773:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103778:	90                   	nop
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103780:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103784:	75 07                	jne    8010378d <runinc+0x2d>
80103786:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
8010378d:	05 8c 00 00 00       	add    $0x8c,%eax
80103792:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103797:	72 e7                	jb     80103780 <runinc+0x20>
80103799:	83 ec 0c             	sub    $0xc,%esp
8010379c:	68 20 2d 11 80       	push   $0x80112d20
801037a1:	e8 4a 0e 00 00       	call   801045f0 <release>
801037a6:	83 c4 10             	add    $0x10,%esp
801037a9:	c9                   	leave  
801037aa:	c3                   	ret    
801037ab:	90                   	nop
801037ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037b0 <mycpu>:
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	56                   	push   %esi
801037b4:	53                   	push   %ebx
801037b5:	9c                   	pushf  
801037b6:	58                   	pop    %eax
801037b7:	f6 c4 02             	test   $0x2,%ah
801037ba:	75 5e                	jne    8010381a <mycpu+0x6a>
801037bc:	e8 6f ef ff ff       	call   80102730 <lapicid>
801037c1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801037c7:	85 f6                	test   %esi,%esi
801037c9:	7e 42                	jle    8010380d <mycpu+0x5d>
801037cb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801037d2:	39 d0                	cmp    %edx,%eax
801037d4:	74 30                	je     80103806 <mycpu+0x56>
801037d6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
801037db:	31 d2                	xor    %edx,%edx
801037dd:	8d 76 00             	lea    0x0(%esi),%esi
801037e0:	83 c2 01             	add    $0x1,%edx
801037e3:	39 f2                	cmp    %esi,%edx
801037e5:	74 26                	je     8010380d <mycpu+0x5d>
801037e7:	0f b6 19             	movzbl (%ecx),%ebx
801037ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037f0:	39 c3                	cmp    %eax,%ebx
801037f2:	75 ec                	jne    801037e0 <mycpu+0x30>
801037f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037fa:	05 80 27 11 80       	add    $0x80112780,%eax
801037ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103802:	5b                   	pop    %ebx
80103803:	5e                   	pop    %esi
80103804:	5d                   	pop    %ebp
80103805:	c3                   	ret    
80103806:	b8 80 27 11 80       	mov    $0x80112780,%eax
8010380b:	eb f2                	jmp    801037ff <mycpu+0x4f>
8010380d:	83 ec 0c             	sub    $0xc,%esp
80103810:	68 7c 76 10 80       	push   $0x8010767c
80103815:	e8 76 cb ff ff       	call   80100390 <panic>
8010381a:	83 ec 0c             	sub    $0xc,%esp
8010381d:	68 58 77 10 80       	push   $0x80107758
80103822:	e8 69 cb ff ff       	call   80100390 <panic>
80103827:	89 f6                	mov    %esi,%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103830 <cpuid>:
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 08             	sub    $0x8,%esp
80103836:	e8 75 ff ff ff       	call   801037b0 <mycpu>
8010383b:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103840:	c9                   	leave  
80103841:	c1 f8 04             	sar    $0x4,%eax
80103844:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
8010384a:	c3                   	ret    
8010384b:	90                   	nop
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103850 <myproc>:
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
80103854:	83 ec 04             	sub    $0x4,%esp
80103857:	e8 04 0c 00 00       	call   80104460 <pushcli>
8010385c:	e8 4f ff ff ff       	call   801037b0 <mycpu>
80103861:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103867:	e8 34 0c 00 00       	call   801044a0 <popcli>
8010386c:	83 c4 04             	add    $0x4,%esp
8010386f:	89 d8                	mov    %ebx,%eax
80103871:	5b                   	pop    %ebx
80103872:	5d                   	pop    %ebp
80103873:	c3                   	ret    
80103874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010387a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103880 <userinit>:
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	53                   	push   %ebx
80103884:	83 ec 04             	sub    $0x4,%esp
80103887:	e8 74 fd ff ff       	call   80103600 <allocproc>
8010388c:	89 c3                	mov    %eax,%ebx
8010388e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
80103893:	e8 e8 35 00 00       	call   80106e80 <setupkvm>
80103898:	85 c0                	test   %eax,%eax
8010389a:	89 43 04             	mov    %eax,0x4(%ebx)
8010389d:	0f 84 bd 00 00 00    	je     80103960 <userinit+0xe0>
801038a3:	83 ec 04             	sub    $0x4,%esp
801038a6:	68 2c 00 00 00       	push   $0x2c
801038ab:	68 60 a4 10 80       	push   $0x8010a460
801038b0:	50                   	push   %eax
801038b1:	e8 aa 32 00 00       	call   80106b60 <inituvm>
801038b6:	83 c4 0c             	add    $0xc,%esp
801038b9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
801038bf:	6a 4c                	push   $0x4c
801038c1:	6a 00                	push   $0x0
801038c3:	ff 73 18             	pushl  0x18(%ebx)
801038c6:	e8 75 0d 00 00       	call   80104640 <memset>
801038cb:	8b 43 18             	mov    0x18(%ebx),%eax
801038ce:	ba 1b 00 00 00       	mov    $0x1b,%edx
801038d3:	b9 23 00 00 00       	mov    $0x23,%ecx
801038d8:	83 c4 0c             	add    $0xc,%esp
801038db:	66 89 50 3c          	mov    %dx,0x3c(%eax)
801038df:	8b 43 18             	mov    0x18(%ebx),%eax
801038e2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
801038e6:	8b 43 18             	mov    0x18(%ebx),%eax
801038e9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038ed:	66 89 50 28          	mov    %dx,0x28(%eax)
801038f1:	8b 43 18             	mov    0x18(%ebx),%eax
801038f4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038f8:	66 89 50 48          	mov    %dx,0x48(%eax)
801038fc:	8b 43 18             	mov    0x18(%ebx),%eax
801038ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
80103906:	8b 43 18             	mov    0x18(%ebx),%eax
80103909:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
80103910:	8b 43 18             	mov    0x18(%ebx),%eax
80103913:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
8010391a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010391d:	6a 10                	push   $0x10
8010391f:	68 a5 76 10 80       	push   $0x801076a5
80103924:	50                   	push   %eax
80103925:	e8 f6 0e 00 00       	call   80104820 <safestrcpy>
8010392a:	c7 04 24 ae 76 10 80 	movl   $0x801076ae,(%esp)
80103931:	e8 aa e5 ff ff       	call   80101ee0 <namei>
80103936:	89 43 68             	mov    %eax,0x68(%ebx)
80103939:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103940:	e8 eb 0b 00 00       	call   80104530 <acquire>
80103945:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
8010394c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103953:	e8 98 0c 00 00       	call   801045f0 <release>
80103958:	83 c4 10             	add    $0x10,%esp
8010395b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010395e:	c9                   	leave  
8010395f:	c3                   	ret    
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	68 8c 76 10 80       	push   $0x8010768c
80103968:	e8 23 ca ff ff       	call   80100390 <panic>
8010396d:	8d 76 00             	lea    0x0(%esi),%esi

80103970 <growproc>:
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	56                   	push   %esi
80103974:	53                   	push   %ebx
80103975:	8b 75 08             	mov    0x8(%ebp),%esi
80103978:	e8 e3 0a 00 00       	call   80104460 <pushcli>
8010397d:	e8 2e fe ff ff       	call   801037b0 <mycpu>
80103982:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103988:	e8 13 0b 00 00       	call   801044a0 <popcli>
8010398d:	83 fe 00             	cmp    $0x0,%esi
80103990:	8b 03                	mov    (%ebx),%eax
80103992:	7f 1c                	jg     801039b0 <growproc+0x40>
80103994:	75 3a                	jne    801039d0 <growproc+0x60>
80103996:	83 ec 0c             	sub    $0xc,%esp
80103999:	89 03                	mov    %eax,(%ebx)
8010399b:	53                   	push   %ebx
8010399c:	e8 af 30 00 00       	call   80106a50 <switchuvm>
801039a1:	83 c4 10             	add    $0x10,%esp
801039a4:	31 c0                	xor    %eax,%eax
801039a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039a9:	5b                   	pop    %ebx
801039aa:	5e                   	pop    %esi
801039ab:	5d                   	pop    %ebp
801039ac:	c3                   	ret    
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
801039b0:	83 ec 04             	sub    $0x4,%esp
801039b3:	01 c6                	add    %eax,%esi
801039b5:	56                   	push   %esi
801039b6:	50                   	push   %eax
801039b7:	ff 73 04             	pushl  0x4(%ebx)
801039ba:	e8 e1 32 00 00       	call   80106ca0 <allocuvm>
801039bf:	83 c4 10             	add    $0x10,%esp
801039c2:	85 c0                	test   %eax,%eax
801039c4:	75 d0                	jne    80103996 <growproc+0x26>
801039c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039cb:	eb d9                	jmp    801039a6 <growproc+0x36>
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
801039d0:	83 ec 04             	sub    $0x4,%esp
801039d3:	01 c6                	add    %eax,%esi
801039d5:	56                   	push   %esi
801039d6:	50                   	push   %eax
801039d7:	ff 73 04             	pushl  0x4(%ebx)
801039da:	e8 f1 33 00 00       	call   80106dd0 <deallocuvm>
801039df:	83 c4 10             	add    $0x10,%esp
801039e2:	85 c0                	test   %eax,%eax
801039e4:	75 b0                	jne    80103996 <growproc+0x26>
801039e6:	eb de                	jmp    801039c6 <growproc+0x56>
801039e8:	90                   	nop
801039e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039f0 <fork>:
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	57                   	push   %edi
801039f4:	56                   	push   %esi
801039f5:	53                   	push   %ebx
801039f6:	83 ec 1c             	sub    $0x1c,%esp
801039f9:	e8 62 0a 00 00       	call   80104460 <pushcli>
801039fe:	e8 ad fd ff ff       	call   801037b0 <mycpu>
80103a03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103a09:	e8 92 0a 00 00       	call   801044a0 <popcli>
80103a0e:	e8 ed fb ff ff       	call   80103600 <allocproc>
80103a13:	85 c0                	test   %eax,%eax
80103a15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a18:	0f 84 b7 00 00 00    	je     80103ad5 <fork+0xe5>
80103a1e:	83 ec 08             	sub    $0x8,%esp
80103a21:	ff 33                	pushl  (%ebx)
80103a23:	ff 73 04             	pushl  0x4(%ebx)
80103a26:	89 c7                	mov    %eax,%edi
80103a28:	e8 23 35 00 00       	call   80106f50 <copyuvm>
80103a2d:	83 c4 10             	add    $0x10,%esp
80103a30:	85 c0                	test   %eax,%eax
80103a32:	89 47 04             	mov    %eax,0x4(%edi)
80103a35:	0f 84 a1 00 00 00    	je     80103adc <fork+0xec>
80103a3b:	8b 03                	mov    (%ebx),%eax
80103a3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a40:	89 01                	mov    %eax,(%ecx)
80103a42:	89 59 14             	mov    %ebx,0x14(%ecx)
80103a45:	89 c8                	mov    %ecx,%eax
80103a47:	8b 79 18             	mov    0x18(%ecx),%edi
80103a4a:	8b 73 18             	mov    0x18(%ebx),%esi
80103a4d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80103a54:	31 f6                	xor    %esi,%esi
80103a56:	8b 40 18             	mov    0x18(%eax),%eax
80103a59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a64:	85 c0                	test   %eax,%eax
80103a66:	74 13                	je     80103a7b <fork+0x8b>
80103a68:	83 ec 0c             	sub    $0xc,%esp
80103a6b:	50                   	push   %eax
80103a6c:	e8 7f d3 ff ff       	call   80100df0 <filedup>
80103a71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a74:	83 c4 10             	add    $0x10,%esp
80103a77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103a7b:	83 c6 01             	add    $0x1,%esi
80103a7e:	83 fe 10             	cmp    $0x10,%esi
80103a81:	75 dd                	jne    80103a60 <fork+0x70>
80103a83:	83 ec 0c             	sub    $0xc,%esp
80103a86:	ff 73 68             	pushl  0x68(%ebx)
80103a89:	83 c3 6c             	add    $0x6c,%ebx
80103a8c:	e8 bf db ff ff       	call   80101650 <idup>
80103a91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a94:	83 c4 0c             	add    $0xc,%esp
80103a97:	89 47 68             	mov    %eax,0x68(%edi)
80103a9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a9d:	6a 10                	push   $0x10
80103a9f:	53                   	push   %ebx
80103aa0:	50                   	push   %eax
80103aa1:	e8 7a 0d 00 00       	call   80104820 <safestrcpy>
80103aa6:	8b 5f 10             	mov    0x10(%edi),%ebx
80103aa9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ab0:	e8 7b 0a 00 00       	call   80104530 <acquire>
80103ab5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
80103abc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ac3:	e8 28 0b 00 00       	call   801045f0 <release>
80103ac8:	83 c4 10             	add    $0x10,%esp
80103acb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ace:	89 d8                	mov    %ebx,%eax
80103ad0:	5b                   	pop    %ebx
80103ad1:	5e                   	pop    %esi
80103ad2:	5f                   	pop    %edi
80103ad3:	5d                   	pop    %ebp
80103ad4:	c3                   	ret    
80103ad5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ada:	eb ef                	jmp    80103acb <fork+0xdb>
80103adc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103adf:	83 ec 0c             	sub    $0xc,%esp
80103ae2:	ff 73 08             	pushl  0x8(%ebx)
80103ae5:	e8 26 e8 ff ff       	call   80102310 <kfree>
80103aea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80103af1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103af8:	83 c4 10             	add    $0x10,%esp
80103afb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b00:	eb c9                	jmp    80103acb <fork+0xdb>
80103b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b10 <scheduler>:
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 0c             	sub    $0xc,%esp
80103b19:	e8 92 fc ff ff       	call   801037b0 <mycpu>
80103b1e:	8d 70 04             	lea    0x4(%eax),%esi
80103b21:	89 c3                	mov    %eax,%ebx
80103b23:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b2a:	00 00 00 
80103b2d:	fb                   	sti    
80103b2e:	83 ec 0c             	sub    $0xc,%esp
80103b31:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
80103b36:	68 20 2d 11 80       	push   $0x80112d20
80103b3b:	e8 f0 09 00 00       	call   80104530 <acquire>
80103b40:	83 c4 10             	add    $0x10,%esp
80103b43:	eb 11                	jmp    80103b56 <scheduler+0x46>
80103b45:	8d 76 00             	lea    0x0(%esi),%esi
80103b48:	81 c7 8c 00 00 00    	add    $0x8c,%edi
80103b4e:	81 ff 54 50 11 80    	cmp    $0x80115054,%edi
80103b54:	73 74                	jae    80103bca <scheduler+0xba>
80103b56:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103b5a:	75 ec                	jne    80103b48 <scheduler+0x38>
80103b5c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b68:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103b6c:	75 0f                	jne    80103b7d <scheduler+0x6d>
80103b6e:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80103b74:	39 97 88 00 00 00    	cmp    %edx,0x88(%edi)
80103b7a:	0f 4f f8             	cmovg  %eax,%edi
80103b7d:	05 8c 00 00 00       	add    $0x8c,%eax
80103b82:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103b87:	72 df                	jb     80103b68 <scheduler+0x58>
80103b89:	83 ec 0c             	sub    $0xc,%esp
80103b8c:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
80103b92:	57                   	push   %edi
80103b93:	81 c7 8c 00 00 00    	add    $0x8c,%edi
80103b99:	e8 b2 2e 00 00       	call   80106a50 <switchuvm>
80103b9e:	c7 47 80 04 00 00 00 	movl   $0x4,-0x80(%edi)
80103ba5:	58                   	pop    %eax
80103ba6:	5a                   	pop    %edx
80103ba7:	ff 77 90             	pushl  -0x70(%edi)
80103baa:	56                   	push   %esi
80103bab:	e8 cb 0c 00 00       	call   8010487b <swtch>
80103bb0:	e8 7b 2e 00 00       	call   80106a30 <switchkvm>
80103bb5:	83 c4 10             	add    $0x10,%esp
80103bb8:	81 ff 54 50 11 80    	cmp    $0x80115054,%edi
80103bbe:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103bc5:	00 00 00 
80103bc8:	72 8c                	jb     80103b56 <scheduler+0x46>
80103bca:	83 ec 0c             	sub    $0xc,%esp
80103bcd:	68 20 2d 11 80       	push   $0x80112d20
80103bd2:	e8 19 0a 00 00       	call   801045f0 <release>
80103bd7:	83 c4 10             	add    $0x10,%esp
80103bda:	e9 4e ff ff ff       	jmp    80103b2d <scheduler+0x1d>
80103bdf:	90                   	nop

80103be0 <sched>:
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	56                   	push   %esi
80103be4:	53                   	push   %ebx
80103be5:	e8 76 08 00 00       	call   80104460 <pushcli>
80103bea:	e8 c1 fb ff ff       	call   801037b0 <mycpu>
80103bef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103bf5:	e8 a6 08 00 00       	call   801044a0 <popcli>
80103bfa:	83 ec 0c             	sub    $0xc,%esp
80103bfd:	68 20 2d 11 80       	push   $0x80112d20
80103c02:	e8 f9 08 00 00       	call   80104500 <holding>
80103c07:	83 c4 10             	add    $0x10,%esp
80103c0a:	85 c0                	test   %eax,%eax
80103c0c:	74 4f                	je     80103c5d <sched+0x7d>
80103c0e:	e8 9d fb ff ff       	call   801037b0 <mycpu>
80103c13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c1a:	75 68                	jne    80103c84 <sched+0xa4>
80103c1c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c20:	74 55                	je     80103c77 <sched+0x97>
80103c22:	9c                   	pushf  
80103c23:	58                   	pop    %eax
80103c24:	f6 c4 02             	test   $0x2,%ah
80103c27:	75 41                	jne    80103c6a <sched+0x8a>
80103c29:	e8 82 fb ff ff       	call   801037b0 <mycpu>
80103c2e:	83 c3 1c             	add    $0x1c,%ebx
80103c31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
80103c37:	e8 74 fb ff ff       	call   801037b0 <mycpu>
80103c3c:	83 ec 08             	sub    $0x8,%esp
80103c3f:	ff 70 04             	pushl  0x4(%eax)
80103c42:	53                   	push   %ebx
80103c43:	e8 33 0c 00 00       	call   8010487b <swtch>
80103c48:	e8 63 fb ff ff       	call   801037b0 <mycpu>
80103c4d:	83 c4 10             	add    $0x10,%esp
80103c50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
80103c56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c59:	5b                   	pop    %ebx
80103c5a:	5e                   	pop    %esi
80103c5b:	5d                   	pop    %ebp
80103c5c:	c3                   	ret    
80103c5d:	83 ec 0c             	sub    $0xc,%esp
80103c60:	68 b0 76 10 80       	push   $0x801076b0
80103c65:	e8 26 c7 ff ff       	call   80100390 <panic>
80103c6a:	83 ec 0c             	sub    $0xc,%esp
80103c6d:	68 dc 76 10 80       	push   $0x801076dc
80103c72:	e8 19 c7 ff ff       	call   80100390 <panic>
80103c77:	83 ec 0c             	sub    $0xc,%esp
80103c7a:	68 ce 76 10 80       	push   $0x801076ce
80103c7f:	e8 0c c7 ff ff       	call   80100390 <panic>
80103c84:	83 ec 0c             	sub    $0xc,%esp
80103c87:	68 c2 76 10 80       	push   $0x801076c2
80103c8c:	e8 ff c6 ff ff       	call   80100390 <panic>
80103c91:	eb 0d                	jmp    80103ca0 <exit>
80103c93:	90                   	nop
80103c94:	90                   	nop
80103c95:	90                   	nop
80103c96:	90                   	nop
80103c97:	90                   	nop
80103c98:	90                   	nop
80103c99:	90                   	nop
80103c9a:	90                   	nop
80103c9b:	90                   	nop
80103c9c:	90                   	nop
80103c9d:	90                   	nop
80103c9e:	90                   	nop
80103c9f:	90                   	nop

80103ca0 <exit>:
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	57                   	push   %edi
80103ca4:	56                   	push   %esi
80103ca5:	53                   	push   %ebx
80103ca6:	83 ec 0c             	sub    $0xc,%esp
80103ca9:	e8 b2 07 00 00       	call   80104460 <pushcli>
80103cae:	e8 fd fa ff ff       	call   801037b0 <mycpu>
80103cb3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
80103cb9:	e8 e2 07 00 00       	call   801044a0 <popcli>
80103cbe:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103cc4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103cc7:	8d 7e 68             	lea    0x68(%esi),%edi
80103cca:	0f 84 fc 00 00 00    	je     80103dcc <exit+0x12c>
80103cd0:	8b 03                	mov    (%ebx),%eax
80103cd2:	85 c0                	test   %eax,%eax
80103cd4:	74 12                	je     80103ce8 <exit+0x48>
80103cd6:	83 ec 0c             	sub    $0xc,%esp
80103cd9:	50                   	push   %eax
80103cda:	e8 61 d1 ff ff       	call   80100e40 <fileclose>
80103cdf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103ce5:	83 c4 10             	add    $0x10,%esp
80103ce8:	83 c3 04             	add    $0x4,%ebx
80103ceb:	39 fb                	cmp    %edi,%ebx
80103ced:	75 e1                	jne    80103cd0 <exit+0x30>
80103cef:	e8 ac ee ff ff       	call   80102ba0 <begin_op>
80103cf4:	83 ec 0c             	sub    $0xc,%esp
80103cf7:	ff 76 68             	pushl  0x68(%esi)
80103cfa:	e8 b1 da ff ff       	call   801017b0 <iput>
80103cff:	e8 0c ef ff ff       	call   80102c10 <end_op>
80103d04:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
80103d0b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d12:	e8 19 08 00 00       	call   80104530 <acquire>
80103d17:	8b 56 14             	mov    0x14(%esi),%edx
80103d1a:	83 c4 10             	add    $0x10,%esp
80103d1d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d22:	eb 10                	jmp    80103d34 <exit+0x94>
80103d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d28:	05 8c 00 00 00       	add    $0x8c,%eax
80103d2d:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103d32:	73 1e                	jae    80103d52 <exit+0xb2>
80103d34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d38:	75 ee                	jne    80103d28 <exit+0x88>
80103d3a:	3b 50 20             	cmp    0x20(%eax),%edx
80103d3d:	75 e9                	jne    80103d28 <exit+0x88>
80103d3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d46:	05 8c 00 00 00       	add    $0x8c,%eax
80103d4b:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103d50:	72 e2                	jb     80103d34 <exit+0x94>
80103d52:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103d58:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103d5d:	eb 0f                	jmp    80103d6e <exit+0xce>
80103d5f:	90                   	nop
80103d60:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103d66:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103d6c:	73 3a                	jae    80103da8 <exit+0x108>
80103d6e:	39 72 14             	cmp    %esi,0x14(%edx)
80103d71:	75 ed                	jne    80103d60 <exit+0xc0>
80103d73:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
80103d77:	89 4a 14             	mov    %ecx,0x14(%edx)
80103d7a:	75 e4                	jne    80103d60 <exit+0xc0>
80103d7c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d81:	eb 11                	jmp    80103d94 <exit+0xf4>
80103d83:	90                   	nop
80103d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d88:	05 8c 00 00 00       	add    $0x8c,%eax
80103d8d:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103d92:	73 cc                	jae    80103d60 <exit+0xc0>
80103d94:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d98:	75 ee                	jne    80103d88 <exit+0xe8>
80103d9a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d9d:	75 e9                	jne    80103d88 <exit+0xe8>
80103d9f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103da6:	eb e0                	jmp    80103d88 <exit+0xe8>
80103da8:	a1 a0 58 11 80       	mov    0x801158a0,%eax
80103dad:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
80103db4:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
80103dba:	e8 21 fe ff ff       	call   80103be0 <sched>
80103dbf:	83 ec 0c             	sub    $0xc,%esp
80103dc2:	68 fd 76 10 80       	push   $0x801076fd
80103dc7:	e8 c4 c5 ff ff       	call   80100390 <panic>
80103dcc:	83 ec 0c             	sub    $0xc,%esp
80103dcf:	68 f0 76 10 80       	push   $0x801076f0
80103dd4:	e8 b7 c5 ff ff       	call   80100390 <panic>
80103dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103de0 <yield>:
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 10             	sub    $0x10,%esp
80103de7:	68 20 2d 11 80       	push   $0x80112d20
80103dec:	e8 3f 07 00 00       	call   80104530 <acquire>
80103df1:	e8 6a 06 00 00       	call   80104460 <pushcli>
80103df6:	e8 b5 f9 ff ff       	call   801037b0 <mycpu>
80103dfb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103e01:	e8 9a 06 00 00       	call   801044a0 <popcli>
80103e06:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
80103e0d:	e8 ce fd ff ff       	call   80103be0 <sched>
80103e12:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e19:	e8 d2 07 00 00       	call   801045f0 <release>
80103e1e:	83 c4 10             	add    $0x10,%esp
80103e21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e24:	c9                   	leave  
80103e25:	c3                   	ret    
80103e26:	8d 76 00             	lea    0x0(%esi),%esi
80103e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e30 <sleep>:
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	57                   	push   %edi
80103e34:	56                   	push   %esi
80103e35:	53                   	push   %ebx
80103e36:	83 ec 0c             	sub    $0xc,%esp
80103e39:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80103e3f:	e8 1c 06 00 00       	call   80104460 <pushcli>
80103e44:	e8 67 f9 ff ff       	call   801037b0 <mycpu>
80103e49:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103e4f:	e8 4c 06 00 00       	call   801044a0 <popcli>
80103e54:	85 db                	test   %ebx,%ebx
80103e56:	0f 84 87 00 00 00    	je     80103ee3 <sleep+0xb3>
80103e5c:	85 f6                	test   %esi,%esi
80103e5e:	74 76                	je     80103ed6 <sleep+0xa6>
80103e60:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103e66:	74 50                	je     80103eb8 <sleep+0x88>
80103e68:	83 ec 0c             	sub    $0xc,%esp
80103e6b:	68 20 2d 11 80       	push   $0x80112d20
80103e70:	e8 bb 06 00 00       	call   80104530 <acquire>
80103e75:	89 34 24             	mov    %esi,(%esp)
80103e78:	e8 73 07 00 00       	call   801045f0 <release>
80103e7d:	89 7b 20             	mov    %edi,0x20(%ebx)
80103e80:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
80103e87:	e8 54 fd ff ff       	call   80103be0 <sched>
80103e8c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103e93:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e9a:	e8 51 07 00 00       	call   801045f0 <release>
80103e9f:	89 75 08             	mov    %esi,0x8(%ebp)
80103ea2:	83 c4 10             	add    $0x10,%esp
80103ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea8:	5b                   	pop    %ebx
80103ea9:	5e                   	pop    %esi
80103eaa:	5f                   	pop    %edi
80103eab:	5d                   	pop    %ebp
80103eac:	e9 7f 06 00 00       	jmp    80104530 <acquire>
80103eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eb8:	89 7b 20             	mov    %edi,0x20(%ebx)
80103ebb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
80103ec2:	e8 19 fd ff ff       	call   80103be0 <sched>
80103ec7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ed1:	5b                   	pop    %ebx
80103ed2:	5e                   	pop    %esi
80103ed3:	5f                   	pop    %edi
80103ed4:	5d                   	pop    %ebp
80103ed5:	c3                   	ret    
80103ed6:	83 ec 0c             	sub    $0xc,%esp
80103ed9:	68 0f 77 10 80       	push   $0x8010770f
80103ede:	e8 ad c4 ff ff       	call   80100390 <panic>
80103ee3:	83 ec 0c             	sub    $0xc,%esp
80103ee6:	68 09 77 10 80       	push   $0x80107709
80103eeb:	e8 a0 c4 ff ff       	call   80100390 <panic>

80103ef0 <wait>:
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
80103ef5:	e8 66 05 00 00       	call   80104460 <pushcli>
80103efa:	e8 b1 f8 ff ff       	call   801037b0 <mycpu>
80103eff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
80103f05:	e8 96 05 00 00       	call   801044a0 <popcli>
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 20 2d 11 80       	push   $0x80112d20
80103f12:	e8 19 06 00 00       	call   80104530 <acquire>
80103f17:	83 c4 10             	add    $0x10,%esp
80103f1a:	31 c0                	xor    %eax,%eax
80103f1c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f21:	eb 13                	jmp    80103f36 <wait+0x46>
80103f23:	90                   	nop
80103f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f28:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103f2e:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103f34:	73 1e                	jae    80103f54 <wait+0x64>
80103f36:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f39:	75 ed                	jne    80103f28 <wait+0x38>
80103f3b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f3f:	74 37                	je     80103f78 <wait+0x88>
80103f41:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103f47:	b8 01 00 00 00       	mov    $0x1,%eax
80103f4c:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103f52:	72 e2                	jb     80103f36 <wait+0x46>
80103f54:	85 c0                	test   %eax,%eax
80103f56:	74 76                	je     80103fce <wait+0xde>
80103f58:	8b 46 24             	mov    0x24(%esi),%eax
80103f5b:	85 c0                	test   %eax,%eax
80103f5d:	75 6f                	jne    80103fce <wait+0xde>
80103f5f:	83 ec 08             	sub    $0x8,%esp
80103f62:	68 20 2d 11 80       	push   $0x80112d20
80103f67:	56                   	push   %esi
80103f68:	e8 c3 fe ff ff       	call   80103e30 <sleep>
80103f6d:	83 c4 10             	add    $0x10,%esp
80103f70:	eb a8                	jmp    80103f1a <wait+0x2a>
80103f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f78:	83 ec 0c             	sub    $0xc,%esp
80103f7b:	ff 73 08             	pushl  0x8(%ebx)
80103f7e:	8b 73 10             	mov    0x10(%ebx),%esi
80103f81:	e8 8a e3 ff ff       	call   80102310 <kfree>
80103f86:	5a                   	pop    %edx
80103f87:	ff 73 04             	pushl  0x4(%ebx)
80103f8a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80103f91:	e8 6a 2e 00 00       	call   80106e00 <freevm>
80103f96:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f9d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
80103fa4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
80103fab:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
80103faf:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
80103fb6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103fbd:	e8 2e 06 00 00       	call   801045f0 <release>
80103fc2:	83 c4 10             	add    $0x10,%esp
80103fc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fc8:	89 f0                	mov    %esi,%eax
80103fca:	5b                   	pop    %ebx
80103fcb:	5e                   	pop    %esi
80103fcc:	5d                   	pop    %ebp
80103fcd:	c3                   	ret    
80103fce:	83 ec 0c             	sub    $0xc,%esp
80103fd1:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103fd6:	68 20 2d 11 80       	push   $0x80112d20
80103fdb:	e8 10 06 00 00       	call   801045f0 <release>
80103fe0:	83 c4 10             	add    $0x10,%esp
80103fe3:	eb e0                	jmp    80103fc5 <wait+0xd5>
80103fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ff0 <wakeup>:
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
80103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ffa:	68 20 2d 11 80       	push   $0x80112d20
80103fff:	e8 2c 05 00 00       	call   80104530 <acquire>
80104004:	83 c4 10             	add    $0x10,%esp
80104007:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010400c:	eb 0e                	jmp    8010401c <wakeup+0x2c>
8010400e:	66 90                	xchg   %ax,%ax
80104010:	05 8c 00 00 00       	add    $0x8c,%eax
80104015:	3d 54 50 11 80       	cmp    $0x80115054,%eax
8010401a:	73 1e                	jae    8010403a <wakeup+0x4a>
8010401c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104020:	75 ee                	jne    80104010 <wakeup+0x20>
80104022:	3b 58 20             	cmp    0x20(%eax),%ebx
80104025:	75 e9                	jne    80104010 <wakeup+0x20>
80104027:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010402e:	05 8c 00 00 00       	add    $0x8c,%eax
80104033:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80104038:	72 e2                	jb     8010401c <wakeup+0x2c>
8010403a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
80104041:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104044:	c9                   	leave  
80104045:	e9 a6 05 00 00       	jmp    801045f0 <release>
8010404a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104050 <kill>:
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
80104054:	83 ec 10             	sub    $0x10,%esp
80104057:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010405a:	68 20 2d 11 80       	push   $0x80112d20
8010405f:	e8 cc 04 00 00       	call   80104530 <acquire>
80104064:	83 c4 10             	add    $0x10,%esp
80104067:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010406c:	eb 0e                	jmp    8010407c <kill+0x2c>
8010406e:	66 90                	xchg   %ax,%ax
80104070:	05 8c 00 00 00       	add    $0x8c,%eax
80104075:	3d 54 50 11 80       	cmp    $0x80115054,%eax
8010407a:	73 34                	jae    801040b0 <kill+0x60>
8010407c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010407f:	75 ef                	jne    80104070 <kill+0x20>
80104081:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104085:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010408c:	75 07                	jne    80104095 <kill+0x45>
8010408e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104095:	83 ec 0c             	sub    $0xc,%esp
80104098:	68 20 2d 11 80       	push   $0x80112d20
8010409d:	e8 4e 05 00 00       	call   801045f0 <release>
801040a2:	83 c4 10             	add    $0x10,%esp
801040a5:	31 c0                	xor    %eax,%eax
801040a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040aa:	c9                   	leave  
801040ab:	c3                   	ret    
801040ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040b0:	83 ec 0c             	sub    $0xc,%esp
801040b3:	68 20 2d 11 80       	push   $0x80112d20
801040b8:	e8 33 05 00 00       	call   801045f0 <release>
801040bd:	83 c4 10             	add    $0x10,%esp
801040c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040c8:	c9                   	leave  
801040c9:	c3                   	ret    
801040ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040d0 <procdump>:
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	57                   	push   %edi
801040d4:	56                   	push   %esi
801040d5:	53                   	push   %ebx
801040d6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801040d9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801040de:	83 ec 3c             	sub    $0x3c,%esp
801040e1:	eb 27                	jmp    8010410a <procdump+0x3a>
801040e3:	90                   	nop
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	68 9b 7a 10 80       	push   $0x80107a9b
801040f0:	e8 6b c5 ff ff       	call   80100660 <cprintf>
801040f5:	83 c4 10             	add    $0x10,%esp
801040f8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801040fe:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104104:	0f 83 86 00 00 00    	jae    80104190 <procdump+0xc0>
8010410a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010410d:	85 c0                	test   %eax,%eax
8010410f:	74 e7                	je     801040f8 <procdump+0x28>
80104111:	83 f8 05             	cmp    $0x5,%eax
80104114:	ba 20 77 10 80       	mov    $0x80107720,%edx
80104119:	77 11                	ja     8010412c <procdump+0x5c>
8010411b:	8b 14 85 80 77 10 80 	mov    -0x7fef8880(,%eax,4),%edx
80104122:	b8 20 77 10 80       	mov    $0x80107720,%eax
80104127:	85 d2                	test   %edx,%edx
80104129:	0f 44 d0             	cmove  %eax,%edx
8010412c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010412f:	50                   	push   %eax
80104130:	52                   	push   %edx
80104131:	ff 73 10             	pushl  0x10(%ebx)
80104134:	68 24 77 10 80       	push   $0x80107724
80104139:	e8 22 c5 ff ff       	call   80100660 <cprintf>
8010413e:	83 c4 10             	add    $0x10,%esp
80104141:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104145:	75 a1                	jne    801040e8 <procdump+0x18>
80104147:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010414a:	83 ec 08             	sub    $0x8,%esp
8010414d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104150:	50                   	push   %eax
80104151:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104154:	8b 40 0c             	mov    0xc(%eax),%eax
80104157:	83 c0 08             	add    $0x8,%eax
8010415a:	50                   	push   %eax
8010415b:	e8 b0 02 00 00       	call   80104410 <getcallerpcs>
80104160:	83 c4 10             	add    $0x10,%esp
80104163:	90                   	nop
80104164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104168:	8b 17                	mov    (%edi),%edx
8010416a:	85 d2                	test   %edx,%edx
8010416c:	0f 84 76 ff ff ff    	je     801040e8 <procdump+0x18>
80104172:	83 ec 08             	sub    $0x8,%esp
80104175:	83 c7 04             	add    $0x4,%edi
80104178:	52                   	push   %edx
80104179:	68 61 71 10 80       	push   $0x80107161
8010417e:	e8 dd c4 ff ff       	call   80100660 <cprintf>
80104183:	83 c4 10             	add    $0x10,%esp
80104186:	39 fe                	cmp    %edi,%esi
80104188:	75 de                	jne    80104168 <procdump+0x98>
8010418a:	e9 59 ff ff ff       	jmp    801040e8 <procdump+0x18>
8010418f:	90                   	nop
80104190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104193:	5b                   	pop    %ebx
80104194:	5e                   	pop    %esi
80104195:	5f                   	pop    %edi
80104196:	5d                   	pop    %ebp
80104197:	c3                   	ret    
80104198:	90                   	nop
80104199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041a0 <waitx>:
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	56                   	push   %esi
801041a4:	53                   	push   %ebx
801041a5:	e8 b6 02 00 00       	call   80104460 <pushcli>
801041aa:	e8 01 f6 ff ff       	call   801037b0 <mycpu>
801041af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
801041b5:	e8 e6 02 00 00       	call   801044a0 <popcli>
801041ba:	83 ec 0c             	sub    $0xc,%esp
801041bd:	68 20 2d 11 80       	push   $0x80112d20
801041c2:	e8 69 03 00 00       	call   80104530 <acquire>
801041c7:	83 c4 10             	add    $0x10,%esp
801041ca:	31 c0                	xor    %eax,%eax
801041cc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801041d1:	eb 13                	jmp    801041e6 <waitx+0x46>
801041d3:	90                   	nop
801041d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801041de:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801041e4:	73 1e                	jae    80104204 <waitx+0x64>
801041e6:	39 73 14             	cmp    %esi,0x14(%ebx)
801041e9:	75 ed                	jne    801041d8 <waitx+0x38>
801041eb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041ef:	74 3f                	je     80104230 <waitx+0x90>
801041f1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801041f7:	b8 01 00 00 00       	mov    $0x1,%eax
801041fc:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80104202:	72 e2                	jb     801041e6 <waitx+0x46>
80104204:	85 c0                	test   %eax,%eax
80104206:	0f 84 99 00 00 00    	je     801042a5 <waitx+0x105>
8010420c:	8b 46 24             	mov    0x24(%esi),%eax
8010420f:	85 c0                	test   %eax,%eax
80104211:	0f 85 8e 00 00 00    	jne    801042a5 <waitx+0x105>
80104217:	83 ec 08             	sub    $0x8,%esp
8010421a:	68 20 2d 11 80       	push   $0x80112d20
8010421f:	56                   	push   %esi
80104220:	e8 0b fc ff ff       	call   80103e30 <sleep>
80104225:	83 c4 10             	add    $0x10,%esp
80104228:	eb a0                	jmp    801041ca <waitx+0x2a>
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104230:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104236:	2b 43 7c             	sub    0x7c(%ebx),%eax
80104239:	83 ec 0c             	sub    $0xc,%esp
8010423c:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
80104242:	8b 55 08             	mov    0x8(%ebp),%edx
80104245:	89 02                	mov    %eax,(%edx)
80104247:	8b 45 0c             	mov    0xc(%ebp),%eax
8010424a:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80104250:	89 10                	mov    %edx,(%eax)
80104252:	ff 73 08             	pushl  0x8(%ebx)
80104255:	8b 73 10             	mov    0x10(%ebx),%esi
80104258:	e8 b3 e0 ff ff       	call   80102310 <kfree>
8010425d:	5a                   	pop    %edx
8010425e:	ff 73 04             	pushl  0x4(%ebx)
80104261:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80104268:	e8 93 2b 00 00       	call   80106e00 <freevm>
8010426d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104274:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
8010427b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
80104282:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
80104286:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
8010428d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80104294:	e8 57 03 00 00       	call   801045f0 <release>
80104299:	83 c4 10             	add    $0x10,%esp
8010429c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010429f:	89 f0                	mov    %esi,%eax
801042a1:	5b                   	pop    %ebx
801042a2:	5e                   	pop    %esi
801042a3:	5d                   	pop    %ebp
801042a4:	c3                   	ret    
801042a5:	83 ec 0c             	sub    $0xc,%esp
801042a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801042ad:	68 20 2d 11 80       	push   $0x80112d20
801042b2:	e8 39 03 00 00       	call   801045f0 <release>
801042b7:	83 c4 10             	add    $0x10,%esp
801042ba:	eb e0                	jmp    8010429c <waitx+0xfc>
801042bc:	66 90                	xchg   %ax,%ax
801042be:	66 90                	xchg   %ax,%ax

801042c0 <initsleeplock>:
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 0c             	sub    $0xc,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042ca:	68 98 77 10 80       	push   $0x80107798
801042cf:	8d 43 04             	lea    0x4(%ebx),%eax
801042d2:	50                   	push   %eax
801042d3:	e8 18 01 00 00       	call   801043f0 <initlock>
801042d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801042db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801042e1:	83 c4 10             	add    $0x10,%esp
801042e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
801042eb:	89 43 38             	mov    %eax,0x38(%ebx)
801042ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f1:	c9                   	leave  
801042f2:	c3                   	ret    
801042f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104300 <acquiresleep>:
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	56                   	push   %esi
80104304:	53                   	push   %ebx
80104305:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	8d 73 04             	lea    0x4(%ebx),%esi
8010430e:	56                   	push   %esi
8010430f:	e8 1c 02 00 00       	call   80104530 <acquire>
80104314:	8b 13                	mov    (%ebx),%edx
80104316:	83 c4 10             	add    $0x10,%esp
80104319:	85 d2                	test   %edx,%edx
8010431b:	74 16                	je     80104333 <acquiresleep+0x33>
8010431d:	8d 76 00             	lea    0x0(%esi),%esi
80104320:	83 ec 08             	sub    $0x8,%esp
80104323:	56                   	push   %esi
80104324:	53                   	push   %ebx
80104325:	e8 06 fb ff ff       	call   80103e30 <sleep>
8010432a:	8b 03                	mov    (%ebx),%eax
8010432c:	83 c4 10             	add    $0x10,%esp
8010432f:	85 c0                	test   %eax,%eax
80104331:	75 ed                	jne    80104320 <acquiresleep+0x20>
80104333:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
80104339:	e8 12 f5 ff ff       	call   80103850 <myproc>
8010433e:	8b 40 10             	mov    0x10(%eax),%eax
80104341:	89 43 3c             	mov    %eax,0x3c(%ebx)
80104344:	89 75 08             	mov    %esi,0x8(%ebp)
80104347:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010434a:	5b                   	pop    %ebx
8010434b:	5e                   	pop    %esi
8010434c:	5d                   	pop    %ebp
8010434d:	e9 9e 02 00 00       	jmp    801045f0 <release>
80104352:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104360 <releasesleep>:
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	56                   	push   %esi
80104364:	53                   	push   %ebx
80104365:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104368:	83 ec 0c             	sub    $0xc,%esp
8010436b:	8d 73 04             	lea    0x4(%ebx),%esi
8010436e:	56                   	push   %esi
8010436f:	e8 bc 01 00 00       	call   80104530 <acquire>
80104374:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010437a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
80104381:	89 1c 24             	mov    %ebx,(%esp)
80104384:	e8 67 fc ff ff       	call   80103ff0 <wakeup>
80104389:	89 75 08             	mov    %esi,0x8(%ebp)
8010438c:	83 c4 10             	add    $0x10,%esp
8010438f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104392:	5b                   	pop    %ebx
80104393:	5e                   	pop    %esi
80104394:	5d                   	pop    %ebp
80104395:	e9 56 02 00 00       	jmp    801045f0 <release>
8010439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043a0 <holdingsleep>:
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	31 ff                	xor    %edi,%edi
801043a8:	83 ec 18             	sub    $0x18,%esp
801043ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043ae:	8d 73 04             	lea    0x4(%ebx),%esi
801043b1:	56                   	push   %esi
801043b2:	e8 79 01 00 00       	call   80104530 <acquire>
801043b7:	8b 03                	mov    (%ebx),%eax
801043b9:	83 c4 10             	add    $0x10,%esp
801043bc:	85 c0                	test   %eax,%eax
801043be:	74 13                	je     801043d3 <holdingsleep+0x33>
801043c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043c3:	e8 88 f4 ff ff       	call   80103850 <myproc>
801043c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801043cb:	0f 94 c0             	sete   %al
801043ce:	0f b6 c0             	movzbl %al,%eax
801043d1:	89 c7                	mov    %eax,%edi
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	56                   	push   %esi
801043d7:	e8 14 02 00 00       	call   801045f0 <release>
801043dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043df:	89 f8                	mov    %edi,%eax
801043e1:	5b                   	pop    %ebx
801043e2:	5e                   	pop    %esi
801043e3:	5f                   	pop    %edi
801043e4:	5d                   	pop    %ebp
801043e5:	c3                   	ret    
801043e6:	66 90                	xchg   %ax,%ax
801043e8:	66 90                	xchg   %ax,%ax
801043ea:	66 90                	xchg   %ax,%ax
801043ec:	66 90                	xchg   %ax,%ax
801043ee:	66 90                	xchg   %ax,%ax

801043f0 <initlock>:
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	8b 45 08             	mov    0x8(%ebp),%eax
801043f6:	8b 55 0c             	mov    0xc(%ebp),%edx
801043f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801043ff:	89 50 04             	mov    %edx,0x4(%eax)
80104402:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104409:	5d                   	pop    %ebp
8010440a:	c3                   	ret    
8010440b:	90                   	nop
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104410 <getcallerpcs>:
80104410:	55                   	push   %ebp
80104411:	31 d2                	xor    %edx,%edx
80104413:	89 e5                	mov    %esp,%ebp
80104415:	53                   	push   %ebx
80104416:	8b 45 08             	mov    0x8(%ebp),%eax
80104419:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010441c:	83 e8 08             	sub    $0x8,%eax
8010441f:	90                   	nop
80104420:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104426:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010442c:	77 1a                	ja     80104448 <getcallerpcs+0x38>
8010442e:	8b 58 04             	mov    0x4(%eax),%ebx
80104431:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
80104434:	83 c2 01             	add    $0x1,%edx
80104437:	8b 00                	mov    (%eax),%eax
80104439:	83 fa 0a             	cmp    $0xa,%edx
8010443c:	75 e2                	jne    80104420 <getcallerpcs+0x10>
8010443e:	5b                   	pop    %ebx
8010443f:	5d                   	pop    %ebp
80104440:	c3                   	ret    
80104441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104448:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010444b:	83 c1 28             	add    $0x28,%ecx
8010444e:	66 90                	xchg   %ax,%ax
80104450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104456:	83 c0 04             	add    $0x4,%eax
80104459:	39 c1                	cmp    %eax,%ecx
8010445b:	75 f3                	jne    80104450 <getcallerpcs+0x40>
8010445d:	5b                   	pop    %ebx
8010445e:	5d                   	pop    %ebp
8010445f:	c3                   	ret    

80104460 <pushcli>:
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 04             	sub    $0x4,%esp
80104467:	9c                   	pushf  
80104468:	5b                   	pop    %ebx
80104469:	fa                   	cli    
8010446a:	e8 41 f3 ff ff       	call   801037b0 <mycpu>
8010446f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104475:	85 c0                	test   %eax,%eax
80104477:	75 11                	jne    8010448a <pushcli+0x2a>
80104479:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010447f:	e8 2c f3 ff ff       	call   801037b0 <mycpu>
80104484:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
8010448a:	e8 21 f3 ff ff       	call   801037b0 <mycpu>
8010448f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
80104496:	83 c4 04             	add    $0x4,%esp
80104499:	5b                   	pop    %ebx
8010449a:	5d                   	pop    %ebp
8010449b:	c3                   	ret    
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044a0 <popcli>:
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	83 ec 08             	sub    $0x8,%esp
801044a6:	9c                   	pushf  
801044a7:	58                   	pop    %eax
801044a8:	f6 c4 02             	test   $0x2,%ah
801044ab:	75 35                	jne    801044e2 <popcli+0x42>
801044ad:	e8 fe f2 ff ff       	call   801037b0 <mycpu>
801044b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044b9:	78 34                	js     801044ef <popcli+0x4f>
801044bb:	e8 f0 f2 ff ff       	call   801037b0 <mycpu>
801044c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044c6:	85 d2                	test   %edx,%edx
801044c8:	74 06                	je     801044d0 <popcli+0x30>
801044ca:	c9                   	leave  
801044cb:	c3                   	ret    
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d0:	e8 db f2 ff ff       	call   801037b0 <mycpu>
801044d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044db:	85 c0                	test   %eax,%eax
801044dd:	74 eb                	je     801044ca <popcli+0x2a>
801044df:	fb                   	sti    
801044e0:	c9                   	leave  
801044e1:	c3                   	ret    
801044e2:	83 ec 0c             	sub    $0xc,%esp
801044e5:	68 a3 77 10 80       	push   $0x801077a3
801044ea:	e8 a1 be ff ff       	call   80100390 <panic>
801044ef:	83 ec 0c             	sub    $0xc,%esp
801044f2:	68 ba 77 10 80       	push   $0x801077ba
801044f7:	e8 94 be ff ff       	call   80100390 <panic>
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104500 <holding>:
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	8b 75 08             	mov    0x8(%ebp),%esi
80104508:	31 db                	xor    %ebx,%ebx
8010450a:	e8 51 ff ff ff       	call   80104460 <pushcli>
8010450f:	8b 06                	mov    (%esi),%eax
80104511:	85 c0                	test   %eax,%eax
80104513:	74 10                	je     80104525 <holding+0x25>
80104515:	8b 5e 08             	mov    0x8(%esi),%ebx
80104518:	e8 93 f2 ff ff       	call   801037b0 <mycpu>
8010451d:	39 c3                	cmp    %eax,%ebx
8010451f:	0f 94 c3             	sete   %bl
80104522:	0f b6 db             	movzbl %bl,%ebx
80104525:	e8 76 ff ff ff       	call   801044a0 <popcli>
8010452a:	89 d8                	mov    %ebx,%eax
8010452c:	5b                   	pop    %ebx
8010452d:	5e                   	pop    %esi
8010452e:	5d                   	pop    %ebp
8010452f:	c3                   	ret    

80104530 <acquire>:
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	e8 26 ff ff ff       	call   80104460 <pushcli>
8010453a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010453d:	83 ec 0c             	sub    $0xc,%esp
80104540:	53                   	push   %ebx
80104541:	e8 ba ff ff ff       	call   80104500 <holding>
80104546:	83 c4 10             	add    $0x10,%esp
80104549:	85 c0                	test   %eax,%eax
8010454b:	0f 85 83 00 00 00    	jne    801045d4 <acquire+0xa4>
80104551:	89 c6                	mov    %eax,%esi
80104553:	ba 01 00 00 00       	mov    $0x1,%edx
80104558:	eb 09                	jmp    80104563 <acquire+0x33>
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104560:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104563:	89 d0                	mov    %edx,%eax
80104565:	f0 87 03             	lock xchg %eax,(%ebx)
80104568:	85 c0                	test   %eax,%eax
8010456a:	75 f4                	jne    80104560 <acquire+0x30>
8010456c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104571:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104574:	e8 37 f2 ff ff       	call   801037b0 <mycpu>
80104579:	8d 53 0c             	lea    0xc(%ebx),%edx
8010457c:	89 43 08             	mov    %eax,0x8(%ebx)
8010457f:	89 e8                	mov    %ebp,%eax
80104581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104588:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010458e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104594:	77 1a                	ja     801045b0 <acquire+0x80>
80104596:	8b 48 04             	mov    0x4(%eax),%ecx
80104599:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
8010459c:	83 c6 01             	add    $0x1,%esi
8010459f:	8b 00                	mov    (%eax),%eax
801045a1:	83 fe 0a             	cmp    $0xa,%esi
801045a4:	75 e2                	jne    80104588 <acquire+0x58>
801045a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045a9:	5b                   	pop    %ebx
801045aa:	5e                   	pop    %esi
801045ab:	5d                   	pop    %ebp
801045ac:	c3                   	ret    
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
801045b0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801045b3:	83 c2 28             	add    $0x28,%edx
801045b6:	8d 76 00             	lea    0x0(%esi),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801045c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801045c6:	83 c0 04             	add    $0x4,%eax
801045c9:	39 d0                	cmp    %edx,%eax
801045cb:	75 f3                	jne    801045c0 <acquire+0x90>
801045cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045d0:	5b                   	pop    %ebx
801045d1:	5e                   	pop    %esi
801045d2:	5d                   	pop    %ebp
801045d3:	c3                   	ret    
801045d4:	83 ec 0c             	sub    $0xc,%esp
801045d7:	68 c1 77 10 80       	push   $0x801077c1
801045dc:	e8 af bd ff ff       	call   80100390 <panic>
801045e1:	eb 0d                	jmp    801045f0 <release>
801045e3:	90                   	nop
801045e4:	90                   	nop
801045e5:	90                   	nop
801045e6:	90                   	nop
801045e7:	90                   	nop
801045e8:	90                   	nop
801045e9:	90                   	nop
801045ea:	90                   	nop
801045eb:	90                   	nop
801045ec:	90                   	nop
801045ed:	90                   	nop
801045ee:	90                   	nop
801045ef:	90                   	nop

801045f0 <release>:
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 10             	sub    $0x10,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045fa:	53                   	push   %ebx
801045fb:	e8 00 ff ff ff       	call   80104500 <holding>
80104600:	83 c4 10             	add    $0x10,%esp
80104603:	85 c0                	test   %eax,%eax
80104605:	74 22                	je     80104629 <release+0x39>
80104607:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
8010460e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80104615:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
8010461a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104620:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104623:	c9                   	leave  
80104624:	e9 77 fe ff ff       	jmp    801044a0 <popcli>
80104629:	83 ec 0c             	sub    $0xc,%esp
8010462c:	68 c9 77 10 80       	push   $0x801077c9
80104631:	e8 5a bd ff ff       	call   80100390 <panic>
80104636:	66 90                	xchg   %ax,%ax
80104638:	66 90                	xchg   %ax,%ax
8010463a:	66 90                	xchg   %ax,%ax
8010463c:	66 90                	xchg   %ax,%ax
8010463e:	66 90                	xchg   %ax,%ax

80104640 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	57                   	push   %edi
80104644:	53                   	push   %ebx
80104645:	8b 55 08             	mov    0x8(%ebp),%edx
80104648:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010464b:	f6 c2 03             	test   $0x3,%dl
8010464e:	75 05                	jne    80104655 <memset+0x15>
80104650:	f6 c1 03             	test   $0x3,%cl
80104653:	74 13                	je     80104668 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104655:	89 d7                	mov    %edx,%edi
80104657:	8b 45 0c             	mov    0xc(%ebp),%eax
8010465a:	fc                   	cld    
8010465b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010465d:	5b                   	pop    %ebx
8010465e:	89 d0                	mov    %edx,%eax
80104660:	5f                   	pop    %edi
80104661:	5d                   	pop    %ebp
80104662:	c3                   	ret    
80104663:	90                   	nop
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104668:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010466c:	c1 e9 02             	shr    $0x2,%ecx
8010466f:	89 f8                	mov    %edi,%eax
80104671:	89 fb                	mov    %edi,%ebx
80104673:	c1 e0 18             	shl    $0x18,%eax
80104676:	c1 e3 10             	shl    $0x10,%ebx
80104679:	09 d8                	or     %ebx,%eax
8010467b:	09 f8                	or     %edi,%eax
8010467d:	c1 e7 08             	shl    $0x8,%edi
80104680:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104682:	89 d7                	mov    %edx,%edi
80104684:	fc                   	cld    
80104685:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104687:	5b                   	pop    %ebx
80104688:	89 d0                	mov    %edx,%eax
8010468a:	5f                   	pop    %edi
8010468b:	5d                   	pop    %ebp
8010468c:	c3                   	ret    
8010468d:	8d 76 00             	lea    0x0(%esi),%esi

80104690 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	56                   	push   %esi
80104695:	53                   	push   %ebx
80104696:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104699:	8b 75 08             	mov    0x8(%ebp),%esi
8010469c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010469f:	85 db                	test   %ebx,%ebx
801046a1:	74 29                	je     801046cc <memcmp+0x3c>
    if(*s1 != *s2)
801046a3:	0f b6 16             	movzbl (%esi),%edx
801046a6:	0f b6 0f             	movzbl (%edi),%ecx
801046a9:	38 d1                	cmp    %dl,%cl
801046ab:	75 2b                	jne    801046d8 <memcmp+0x48>
801046ad:	b8 01 00 00 00       	mov    $0x1,%eax
801046b2:	eb 14                	jmp    801046c8 <memcmp+0x38>
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801046bc:	83 c0 01             	add    $0x1,%eax
801046bf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801046c4:	38 ca                	cmp    %cl,%dl
801046c6:	75 10                	jne    801046d8 <memcmp+0x48>
  while(n-- > 0){
801046c8:	39 d8                	cmp    %ebx,%eax
801046ca:	75 ec                	jne    801046b8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801046cc:	5b                   	pop    %ebx
  return 0;
801046cd:	31 c0                	xor    %eax,%eax
}
801046cf:	5e                   	pop    %esi
801046d0:	5f                   	pop    %edi
801046d1:	5d                   	pop    %ebp
801046d2:	c3                   	ret    
801046d3:	90                   	nop
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801046d8:	0f b6 c2             	movzbl %dl,%eax
}
801046db:	5b                   	pop    %ebx
      return *s1 - *s2;
801046dc:	29 c8                	sub    %ecx,%eax
}
801046de:	5e                   	pop    %esi
801046df:	5f                   	pop    %edi
801046e0:	5d                   	pop    %ebp
801046e1:	c3                   	ret    
801046e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	56                   	push   %esi
801046f4:	53                   	push   %ebx
801046f5:	8b 45 08             	mov    0x8(%ebp),%eax
801046f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801046fb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801046fe:	39 c3                	cmp    %eax,%ebx
80104700:	73 26                	jae    80104728 <memmove+0x38>
80104702:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104705:	39 c8                	cmp    %ecx,%eax
80104707:	73 1f                	jae    80104728 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104709:	85 f6                	test   %esi,%esi
8010470b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010470e:	74 0f                	je     8010471f <memmove+0x2f>
      *--d = *--s;
80104710:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104714:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104717:	83 ea 01             	sub    $0x1,%edx
8010471a:	83 fa ff             	cmp    $0xffffffff,%edx
8010471d:	75 f1                	jne    80104710 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010471f:	5b                   	pop    %ebx
80104720:	5e                   	pop    %esi
80104721:	5d                   	pop    %ebp
80104722:	c3                   	ret    
80104723:	90                   	nop
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104728:	31 d2                	xor    %edx,%edx
8010472a:	85 f6                	test   %esi,%esi
8010472c:	74 f1                	je     8010471f <memmove+0x2f>
8010472e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104730:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104734:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104737:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010473a:	39 d6                	cmp    %edx,%esi
8010473c:	75 f2                	jne    80104730 <memmove+0x40>
}
8010473e:	5b                   	pop    %ebx
8010473f:	5e                   	pop    %esi
80104740:	5d                   	pop    %ebp
80104741:	c3                   	ret    
80104742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104750 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104753:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104754:	eb 9a                	jmp    801046f0 <memmove>
80104756:	8d 76 00             	lea    0x0(%esi),%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104760 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	57                   	push   %edi
80104764:	56                   	push   %esi
80104765:	8b 7d 10             	mov    0x10(%ebp),%edi
80104768:	53                   	push   %ebx
80104769:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010476c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010476f:	85 ff                	test   %edi,%edi
80104771:	74 2f                	je     801047a2 <strncmp+0x42>
80104773:	0f b6 01             	movzbl (%ecx),%eax
80104776:	0f b6 1e             	movzbl (%esi),%ebx
80104779:	84 c0                	test   %al,%al
8010477b:	74 37                	je     801047b4 <strncmp+0x54>
8010477d:	38 c3                	cmp    %al,%bl
8010477f:	75 33                	jne    801047b4 <strncmp+0x54>
80104781:	01 f7                	add    %esi,%edi
80104783:	eb 13                	jmp    80104798 <strncmp+0x38>
80104785:	8d 76 00             	lea    0x0(%esi),%esi
80104788:	0f b6 01             	movzbl (%ecx),%eax
8010478b:	84 c0                	test   %al,%al
8010478d:	74 21                	je     801047b0 <strncmp+0x50>
8010478f:	0f b6 1a             	movzbl (%edx),%ebx
80104792:	89 d6                	mov    %edx,%esi
80104794:	38 d8                	cmp    %bl,%al
80104796:	75 1c                	jne    801047b4 <strncmp+0x54>
    n--, p++, q++;
80104798:	8d 56 01             	lea    0x1(%esi),%edx
8010479b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010479e:	39 fa                	cmp    %edi,%edx
801047a0:	75 e6                	jne    80104788 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801047a2:	5b                   	pop    %ebx
    return 0;
801047a3:	31 c0                	xor    %eax,%eax
}
801047a5:	5e                   	pop    %esi
801047a6:	5f                   	pop    %edi
801047a7:	5d                   	pop    %ebp
801047a8:	c3                   	ret    
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047b0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801047b4:	29 d8                	sub    %ebx,%eax
}
801047b6:	5b                   	pop    %ebx
801047b7:	5e                   	pop    %esi
801047b8:	5f                   	pop    %edi
801047b9:	5d                   	pop    %ebp
801047ba:	c3                   	ret    
801047bb:	90                   	nop
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
801047c5:	8b 45 08             	mov    0x8(%ebp),%eax
801047c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801047cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047ce:	89 c2                	mov    %eax,%edx
801047d0:	eb 19                	jmp    801047eb <strncpy+0x2b>
801047d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047d8:	83 c3 01             	add    $0x1,%ebx
801047db:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801047df:	83 c2 01             	add    $0x1,%edx
801047e2:	84 c9                	test   %cl,%cl
801047e4:	88 4a ff             	mov    %cl,-0x1(%edx)
801047e7:	74 09                	je     801047f2 <strncpy+0x32>
801047e9:	89 f1                	mov    %esi,%ecx
801047eb:	85 c9                	test   %ecx,%ecx
801047ed:	8d 71 ff             	lea    -0x1(%ecx),%esi
801047f0:	7f e6                	jg     801047d8 <strncpy+0x18>
    ;
  while(n-- > 0)
801047f2:	31 c9                	xor    %ecx,%ecx
801047f4:	85 f6                	test   %esi,%esi
801047f6:	7e 17                	jle    8010480f <strncpy+0x4f>
801047f8:	90                   	nop
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104800:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104804:	89 f3                	mov    %esi,%ebx
80104806:	83 c1 01             	add    $0x1,%ecx
80104809:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010480b:	85 db                	test   %ebx,%ebx
8010480d:	7f f1                	jg     80104800 <strncpy+0x40>
  return os;
}
8010480f:	5b                   	pop    %ebx
80104810:	5e                   	pop    %esi
80104811:	5d                   	pop    %ebp
80104812:	c3                   	ret    
80104813:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104828:	8b 45 08             	mov    0x8(%ebp),%eax
8010482b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010482e:	85 c9                	test   %ecx,%ecx
80104830:	7e 26                	jle    80104858 <safestrcpy+0x38>
80104832:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104836:	89 c1                	mov    %eax,%ecx
80104838:	eb 17                	jmp    80104851 <safestrcpy+0x31>
8010483a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104840:	83 c2 01             	add    $0x1,%edx
80104843:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104847:	83 c1 01             	add    $0x1,%ecx
8010484a:	84 db                	test   %bl,%bl
8010484c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010484f:	74 04                	je     80104855 <safestrcpy+0x35>
80104851:	39 f2                	cmp    %esi,%edx
80104853:	75 eb                	jne    80104840 <safestrcpy+0x20>
    ;
  *s = 0;
80104855:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104858:	5b                   	pop    %ebx
80104859:	5e                   	pop    %esi
8010485a:	5d                   	pop    %ebp
8010485b:	c3                   	ret    
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104860 <strlen>:

int
strlen(const char *s)
{
80104860:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104861:	31 c0                	xor    %eax,%eax
{
80104863:	89 e5                	mov    %esp,%ebp
80104865:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104868:	80 3a 00             	cmpb   $0x0,(%edx)
8010486b:	74 0c                	je     80104879 <strlen+0x19>
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
80104870:	83 c0 01             	add    $0x1,%eax
80104873:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104877:	75 f7                	jne    80104870 <strlen+0x10>
    ;
  return n;
}
80104879:	5d                   	pop    %ebp
8010487a:	c3                   	ret    

8010487b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010487b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010487f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104883:	55                   	push   %ebp
  pushl %ebx
80104884:	53                   	push   %ebx
  pushl %esi
80104885:	56                   	push   %esi
  pushl %edi
80104886:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104887:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104889:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010488b:	5f                   	pop    %edi
  popl %esi
8010488c:	5e                   	pop    %esi
  popl %ebx
8010488d:	5b                   	pop    %ebx
  popl %ebp
8010488e:	5d                   	pop    %ebp
  ret
8010488f:	c3                   	ret    

80104890 <fetchint>:
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 04             	sub    $0x4,%esp
80104897:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010489a:	e8 b1 ef ff ff       	call   80103850 <myproc>
8010489f:	8b 00                	mov    (%eax),%eax
801048a1:	39 d8                	cmp    %ebx,%eax
801048a3:	76 1b                	jbe    801048c0 <fetchint+0x30>
801048a5:	8d 53 04             	lea    0x4(%ebx),%edx
801048a8:	39 d0                	cmp    %edx,%eax
801048aa:	72 14                	jb     801048c0 <fetchint+0x30>
801048ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801048af:	8b 13                	mov    (%ebx),%edx
801048b1:	89 10                	mov    %edx,(%eax)
801048b3:	31 c0                	xor    %eax,%eax
801048b5:	83 c4 04             	add    $0x4,%esp
801048b8:	5b                   	pop    %ebx
801048b9:	5d                   	pop    %ebp
801048ba:	c3                   	ret    
801048bb:	90                   	nop
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048c5:	eb ee                	jmp    801048b5 <fetchint+0x25>
801048c7:	89 f6                	mov    %esi,%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048d0 <fetchstr>:
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 04             	sub    $0x4,%esp
801048d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048da:	e8 71 ef ff ff       	call   80103850 <myproc>
801048df:	39 18                	cmp    %ebx,(%eax)
801048e1:	76 29                	jbe    8010490c <fetchstr+0x3c>
801048e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801048e6:	89 da                	mov    %ebx,%edx
801048e8:	89 19                	mov    %ebx,(%ecx)
801048ea:	8b 00                	mov    (%eax),%eax
801048ec:	39 c3                	cmp    %eax,%ebx
801048ee:	73 1c                	jae    8010490c <fetchstr+0x3c>
801048f0:	80 3b 00             	cmpb   $0x0,(%ebx)
801048f3:	75 10                	jne    80104905 <fetchstr+0x35>
801048f5:	eb 39                	jmp    80104930 <fetchstr+0x60>
801048f7:	89 f6                	mov    %esi,%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104900:	80 3a 00             	cmpb   $0x0,(%edx)
80104903:	74 1b                	je     80104920 <fetchstr+0x50>
80104905:	83 c2 01             	add    $0x1,%edx
80104908:	39 d0                	cmp    %edx,%eax
8010490a:	77 f4                	ja     80104900 <fetchstr+0x30>
8010490c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104911:	83 c4 04             	add    $0x4,%esp
80104914:	5b                   	pop    %ebx
80104915:	5d                   	pop    %ebp
80104916:	c3                   	ret    
80104917:	89 f6                	mov    %esi,%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104920:	83 c4 04             	add    $0x4,%esp
80104923:	89 d0                	mov    %edx,%eax
80104925:	29 d8                	sub    %ebx,%eax
80104927:	5b                   	pop    %ebx
80104928:	5d                   	pop    %ebp
80104929:	c3                   	ret    
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104930:	31 c0                	xor    %eax,%eax
80104932:	eb dd                	jmp    80104911 <fetchstr+0x41>
80104934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010493a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104940 <argint>:
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	e8 06 ef ff ff       	call   80103850 <myproc>
8010494a:	8b 40 18             	mov    0x18(%eax),%eax
8010494d:	8b 55 08             	mov    0x8(%ebp),%edx
80104950:	8b 40 44             	mov    0x44(%eax),%eax
80104953:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104956:	e8 f5 ee ff ff       	call   80103850 <myproc>
8010495b:	8b 00                	mov    (%eax),%eax
8010495d:	8d 73 04             	lea    0x4(%ebx),%esi
80104960:	39 c6                	cmp    %eax,%esi
80104962:	73 1c                	jae    80104980 <argint+0x40>
80104964:	8d 53 08             	lea    0x8(%ebx),%edx
80104967:	39 d0                	cmp    %edx,%eax
80104969:	72 15                	jb     80104980 <argint+0x40>
8010496b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010496e:	8b 53 04             	mov    0x4(%ebx),%edx
80104971:	89 10                	mov    %edx,(%eax)
80104973:	31 c0                	xor    %eax,%eax
80104975:	5b                   	pop    %ebx
80104976:	5e                   	pop    %esi
80104977:	5d                   	pop    %ebp
80104978:	c3                   	ret    
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104985:	eb ee                	jmp    80104975 <argint+0x35>
80104987:	89 f6                	mov    %esi,%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104990 <argptr>:
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	53                   	push   %ebx
80104995:	83 ec 10             	sub    $0x10,%esp
80104998:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010499b:	e8 b0 ee ff ff       	call   80103850 <myproc>
801049a0:	89 c6                	mov    %eax,%esi
801049a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049a5:	83 ec 08             	sub    $0x8,%esp
801049a8:	50                   	push   %eax
801049a9:	ff 75 08             	pushl  0x8(%ebp)
801049ac:	e8 8f ff ff ff       	call   80104940 <argint>
801049b1:	83 c4 10             	add    $0x10,%esp
801049b4:	85 c0                	test   %eax,%eax
801049b6:	78 28                	js     801049e0 <argptr+0x50>
801049b8:	85 db                	test   %ebx,%ebx
801049ba:	78 24                	js     801049e0 <argptr+0x50>
801049bc:	8b 16                	mov    (%esi),%edx
801049be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c1:	39 c2                	cmp    %eax,%edx
801049c3:	76 1b                	jbe    801049e0 <argptr+0x50>
801049c5:	01 c3                	add    %eax,%ebx
801049c7:	39 da                	cmp    %ebx,%edx
801049c9:	72 15                	jb     801049e0 <argptr+0x50>
801049cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801049ce:	89 02                	mov    %eax,(%edx)
801049d0:	31 c0                	xor    %eax,%eax
801049d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d5:	5b                   	pop    %ebx
801049d6:	5e                   	pop    %esi
801049d7:	5d                   	pop    %ebp
801049d8:	c3                   	ret    
801049d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049e5:	eb eb                	jmp    801049d2 <argptr+0x42>
801049e7:	89 f6                	mov    %esi,%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <argstr>:
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	83 ec 20             	sub    $0x20,%esp
801049f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049f9:	50                   	push   %eax
801049fa:	ff 75 08             	pushl  0x8(%ebp)
801049fd:	e8 3e ff ff ff       	call   80104940 <argint>
80104a02:	83 c4 10             	add    $0x10,%esp
80104a05:	85 c0                	test   %eax,%eax
80104a07:	78 17                	js     80104a20 <argstr+0x30>
80104a09:	83 ec 08             	sub    $0x8,%esp
80104a0c:	ff 75 0c             	pushl  0xc(%ebp)
80104a0f:	ff 75 f4             	pushl  -0xc(%ebp)
80104a12:	e8 b9 fe ff ff       	call   801048d0 <fetchstr>
80104a17:	83 c4 10             	add    $0x10,%esp
80104a1a:	c9                   	leave  
80104a1b:	c3                   	ret    
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a25:	c9                   	leave  
80104a26:	c3                   	ret    
80104a27:	89 f6                	mov    %esi,%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <syscall>:
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 04             	sub    $0x4,%esp
80104a37:	e8 14 ee ff ff       	call   80103850 <myproc>
80104a3c:	89 c3                	mov    %eax,%ebx
80104a3e:	8b 40 18             	mov    0x18(%eax),%eax
80104a41:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a44:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a47:	83 fa 15             	cmp    $0x15,%edx
80104a4a:	77 1c                	ja     80104a68 <syscall+0x38>
80104a4c:	8b 14 85 00 78 10 80 	mov    -0x7fef8800(,%eax,4),%edx
80104a53:	85 d2                	test   %edx,%edx
80104a55:	74 11                	je     80104a68 <syscall+0x38>
80104a57:	ff d2                	call   *%edx
80104a59:	8b 53 18             	mov    0x18(%ebx),%edx
80104a5c:	89 42 1c             	mov    %eax,0x1c(%edx)
80104a5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a62:	c9                   	leave  
80104a63:	c3                   	ret    
80104a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a68:	50                   	push   %eax
80104a69:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104a6c:	50                   	push   %eax
80104a6d:	ff 73 10             	pushl  0x10(%ebx)
80104a70:	68 d1 77 10 80       	push   $0x801077d1
80104a75:	e8 e6 bb ff ff       	call   80100660 <cprintf>
80104a7a:	8b 43 18             	mov    0x18(%ebx),%eax
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104a87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a8a:	c9                   	leave  
80104a8b:	c3                   	ret    
80104a8c:	66 90                	xchg   %ax,%ax
80104a8e:	66 90                	xchg   %ax,%ax

80104a90 <create>:
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	53                   	push   %ebx
80104a96:	8d 75 da             	lea    -0x26(%ebp),%esi
80104a99:	83 ec 34             	sub    $0x34,%esp
80104a9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104a9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104aa2:	56                   	push   %esi
80104aa3:	50                   	push   %eax
80104aa4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104aa7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80104aaa:	e8 51 d4 ff ff       	call   80101f00 <nameiparent>
80104aaf:	83 c4 10             	add    $0x10,%esp
80104ab2:	85 c0                	test   %eax,%eax
80104ab4:	0f 84 46 01 00 00    	je     80104c00 <create+0x170>
80104aba:	83 ec 0c             	sub    $0xc,%esp
80104abd:	89 c3                	mov    %eax,%ebx
80104abf:	50                   	push   %eax
80104ac0:	e8 bb cb ff ff       	call   80101680 <ilock>
80104ac5:	83 c4 0c             	add    $0xc,%esp
80104ac8:	6a 00                	push   $0x0
80104aca:	56                   	push   %esi
80104acb:	53                   	push   %ebx
80104acc:	e8 df d0 ff ff       	call   80101bb0 <dirlookup>
80104ad1:	83 c4 10             	add    $0x10,%esp
80104ad4:	85 c0                	test   %eax,%eax
80104ad6:	89 c7                	mov    %eax,%edi
80104ad8:	74 36                	je     80104b10 <create+0x80>
80104ada:	83 ec 0c             	sub    $0xc,%esp
80104add:	53                   	push   %ebx
80104ade:	e8 2d ce ff ff       	call   80101910 <iunlockput>
80104ae3:	89 3c 24             	mov    %edi,(%esp)
80104ae6:	e8 95 cb ff ff       	call   80101680 <ilock>
80104aeb:	83 c4 10             	add    $0x10,%esp
80104aee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104af3:	0f 85 97 00 00 00    	jne    80104b90 <create+0x100>
80104af9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104afe:	0f 85 8c 00 00 00    	jne    80104b90 <create+0x100>
80104b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b07:	89 f8                	mov    %edi,%eax
80104b09:	5b                   	pop    %ebx
80104b0a:	5e                   	pop    %esi
80104b0b:	5f                   	pop    %edi
80104b0c:	5d                   	pop    %ebp
80104b0d:	c3                   	ret    
80104b0e:	66 90                	xchg   %ax,%ax
80104b10:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104b14:	83 ec 08             	sub    $0x8,%esp
80104b17:	50                   	push   %eax
80104b18:	ff 33                	pushl  (%ebx)
80104b1a:	e8 f1 c9 ff ff       	call   80101510 <ialloc>
80104b1f:	83 c4 10             	add    $0x10,%esp
80104b22:	85 c0                	test   %eax,%eax
80104b24:	89 c7                	mov    %eax,%edi
80104b26:	0f 84 e8 00 00 00    	je     80104c14 <create+0x184>
80104b2c:	83 ec 0c             	sub    $0xc,%esp
80104b2f:	50                   	push   %eax
80104b30:	e8 4b cb ff ff       	call   80101680 <ilock>
80104b35:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104b39:	66 89 47 52          	mov    %ax,0x52(%edi)
80104b3d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104b41:	66 89 47 54          	mov    %ax,0x54(%edi)
80104b45:	b8 01 00 00 00       	mov    $0x1,%eax
80104b4a:	66 89 47 56          	mov    %ax,0x56(%edi)
80104b4e:	89 3c 24             	mov    %edi,(%esp)
80104b51:	e8 7a ca ff ff       	call   801015d0 <iupdate>
80104b56:	83 c4 10             	add    $0x10,%esp
80104b59:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104b5e:	74 50                	je     80104bb0 <create+0x120>
80104b60:	83 ec 04             	sub    $0x4,%esp
80104b63:	ff 77 04             	pushl  0x4(%edi)
80104b66:	56                   	push   %esi
80104b67:	53                   	push   %ebx
80104b68:	e8 b3 d2 ff ff       	call   80101e20 <dirlink>
80104b6d:	83 c4 10             	add    $0x10,%esp
80104b70:	85 c0                	test   %eax,%eax
80104b72:	0f 88 8f 00 00 00    	js     80104c07 <create+0x177>
80104b78:	83 ec 0c             	sub    $0xc,%esp
80104b7b:	53                   	push   %ebx
80104b7c:	e8 8f cd ff ff       	call   80101910 <iunlockput>
80104b81:	83 c4 10             	add    $0x10,%esp
80104b84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b87:	89 f8                	mov    %edi,%eax
80104b89:	5b                   	pop    %ebx
80104b8a:	5e                   	pop    %esi
80104b8b:	5f                   	pop    %edi
80104b8c:	5d                   	pop    %ebp
80104b8d:	c3                   	ret    
80104b8e:	66 90                	xchg   %ax,%ax
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	57                   	push   %edi
80104b94:	31 ff                	xor    %edi,%edi
80104b96:	e8 75 cd ff ff       	call   80101910 <iunlockput>
80104b9b:	83 c4 10             	add    $0x10,%esp
80104b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba1:	89 f8                	mov    %edi,%eax
80104ba3:	5b                   	pop    %ebx
80104ba4:	5e                   	pop    %esi
80104ba5:	5f                   	pop    %edi
80104ba6:	5d                   	pop    %ebp
80104ba7:	c3                   	ret    
80104ba8:	90                   	nop
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bb0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
80104bb5:	83 ec 0c             	sub    $0xc,%esp
80104bb8:	53                   	push   %ebx
80104bb9:	e8 12 ca ff ff       	call   801015d0 <iupdate>
80104bbe:	83 c4 0c             	add    $0xc,%esp
80104bc1:	ff 77 04             	pushl  0x4(%edi)
80104bc4:	68 78 78 10 80       	push   $0x80107878
80104bc9:	57                   	push   %edi
80104bca:	e8 51 d2 ff ff       	call   80101e20 <dirlink>
80104bcf:	83 c4 10             	add    $0x10,%esp
80104bd2:	85 c0                	test   %eax,%eax
80104bd4:	78 1c                	js     80104bf2 <create+0x162>
80104bd6:	83 ec 04             	sub    $0x4,%esp
80104bd9:	ff 73 04             	pushl  0x4(%ebx)
80104bdc:	68 77 78 10 80       	push   $0x80107877
80104be1:	57                   	push   %edi
80104be2:	e8 39 d2 ff ff       	call   80101e20 <dirlink>
80104be7:	83 c4 10             	add    $0x10,%esp
80104bea:	85 c0                	test   %eax,%eax
80104bec:	0f 89 6e ff ff ff    	jns    80104b60 <create+0xd0>
80104bf2:	83 ec 0c             	sub    $0xc,%esp
80104bf5:	68 6b 78 10 80       	push   $0x8010786b
80104bfa:	e8 91 b7 ff ff       	call   80100390 <panic>
80104bff:	90                   	nop
80104c00:	31 ff                	xor    %edi,%edi
80104c02:	e9 fd fe ff ff       	jmp    80104b04 <create+0x74>
80104c07:	83 ec 0c             	sub    $0xc,%esp
80104c0a:	68 7a 78 10 80       	push   $0x8010787a
80104c0f:	e8 7c b7 ff ff       	call   80100390 <panic>
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	68 5c 78 10 80       	push   $0x8010785c
80104c1c:	e8 6f b7 ff ff       	call   80100390 <panic>
80104c21:	eb 0d                	jmp    80104c30 <argfd.constprop.0>
80104c23:	90                   	nop
80104c24:	90                   	nop
80104c25:	90                   	nop
80104c26:	90                   	nop
80104c27:	90                   	nop
80104c28:	90                   	nop
80104c29:	90                   	nop
80104c2a:	90                   	nop
80104c2b:	90                   	nop
80104c2c:	90                   	nop
80104c2d:	90                   	nop
80104c2e:	90                   	nop
80104c2f:	90                   	nop

80104c30 <argfd.constprop.0>:
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
80104c35:	89 c3                	mov    %eax,%ebx
80104c37:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c3a:	89 d6                	mov    %edx,%esi
80104c3c:	83 ec 18             	sub    $0x18,%esp
80104c3f:	50                   	push   %eax
80104c40:	6a 00                	push   $0x0
80104c42:	e8 f9 fc ff ff       	call   80104940 <argint>
80104c47:	83 c4 10             	add    $0x10,%esp
80104c4a:	85 c0                	test   %eax,%eax
80104c4c:	78 2a                	js     80104c78 <argfd.constprop.0+0x48>
80104c4e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c52:	77 24                	ja     80104c78 <argfd.constprop.0+0x48>
80104c54:	e8 f7 eb ff ff       	call   80103850 <myproc>
80104c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c5c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c60:	85 c0                	test   %eax,%eax
80104c62:	74 14                	je     80104c78 <argfd.constprop.0+0x48>
80104c64:	85 db                	test   %ebx,%ebx
80104c66:	74 02                	je     80104c6a <argfd.constprop.0+0x3a>
80104c68:	89 13                	mov    %edx,(%ebx)
80104c6a:	89 06                	mov    %eax,(%esi)
80104c6c:	31 c0                	xor    %eax,%eax
80104c6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c71:	5b                   	pop    %ebx
80104c72:	5e                   	pop    %esi
80104c73:	5d                   	pop    %ebp
80104c74:	c3                   	ret    
80104c75:	8d 76 00             	lea    0x0(%esi),%esi
80104c78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c7d:	eb ef                	jmp    80104c6e <argfd.constprop.0+0x3e>
80104c7f:	90                   	nop

80104c80 <sys_dup>:
80104c80:	55                   	push   %ebp
80104c81:	31 c0                	xor    %eax,%eax
80104c83:	89 e5                	mov    %esp,%ebp
80104c85:	56                   	push   %esi
80104c86:	53                   	push   %ebx
80104c87:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c8a:	83 ec 10             	sub    $0x10,%esp
80104c8d:	e8 9e ff ff ff       	call   80104c30 <argfd.constprop.0>
80104c92:	85 c0                	test   %eax,%eax
80104c94:	78 42                	js     80104cd8 <sys_dup+0x58>
80104c96:	8b 75 f4             	mov    -0xc(%ebp),%esi
80104c99:	31 db                	xor    %ebx,%ebx
80104c9b:	e8 b0 eb ff ff       	call   80103850 <myproc>
80104ca0:	eb 0e                	jmp    80104cb0 <sys_dup+0x30>
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ca8:	83 c3 01             	add    $0x1,%ebx
80104cab:	83 fb 10             	cmp    $0x10,%ebx
80104cae:	74 28                	je     80104cd8 <sys_dup+0x58>
80104cb0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104cb4:	85 d2                	test   %edx,%edx
80104cb6:	75 f0                	jne    80104ca8 <sys_dup+0x28>
80104cb8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
80104cbc:	83 ec 0c             	sub    $0xc,%esp
80104cbf:	ff 75 f4             	pushl  -0xc(%ebp)
80104cc2:	e8 29 c1 ff ff       	call   80100df0 <filedup>
80104cc7:	83 c4 10             	add    $0x10,%esp
80104cca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ccd:	89 d8                	mov    %ebx,%eax
80104ccf:	5b                   	pop    %ebx
80104cd0:	5e                   	pop    %esi
80104cd1:	5d                   	pop    %ebp
80104cd2:	c3                   	ret    
80104cd3:	90                   	nop
80104cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cdb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104ce0:	89 d8                	mov    %ebx,%eax
80104ce2:	5b                   	pop    %ebx
80104ce3:	5e                   	pop    %esi
80104ce4:	5d                   	pop    %ebp
80104ce5:	c3                   	ret    
80104ce6:	8d 76 00             	lea    0x0(%esi),%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <sys_read>:
80104cf0:	55                   	push   %ebp
80104cf1:	31 c0                	xor    %eax,%eax
80104cf3:	89 e5                	mov    %esp,%ebp
80104cf5:	83 ec 18             	sub    $0x18,%esp
80104cf8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cfb:	e8 30 ff ff ff       	call   80104c30 <argfd.constprop.0>
80104d00:	85 c0                	test   %eax,%eax
80104d02:	78 4c                	js     80104d50 <sys_read+0x60>
80104d04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d07:	83 ec 08             	sub    $0x8,%esp
80104d0a:	50                   	push   %eax
80104d0b:	6a 02                	push   $0x2
80104d0d:	e8 2e fc ff ff       	call   80104940 <argint>
80104d12:	83 c4 10             	add    $0x10,%esp
80104d15:	85 c0                	test   %eax,%eax
80104d17:	78 37                	js     80104d50 <sys_read+0x60>
80104d19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d1c:	83 ec 04             	sub    $0x4,%esp
80104d1f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d22:	50                   	push   %eax
80104d23:	6a 01                	push   $0x1
80104d25:	e8 66 fc ff ff       	call   80104990 <argptr>
80104d2a:	83 c4 10             	add    $0x10,%esp
80104d2d:	85 c0                	test   %eax,%eax
80104d2f:	78 1f                	js     80104d50 <sys_read+0x60>
80104d31:	83 ec 04             	sub    $0x4,%esp
80104d34:	ff 75 f0             	pushl  -0x10(%ebp)
80104d37:	ff 75 f4             	pushl  -0xc(%ebp)
80104d3a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d3d:	e8 1e c2 ff ff       	call   80100f60 <fileread>
80104d42:	83 c4 10             	add    $0x10,%esp
80104d45:	c9                   	leave  
80104d46:	c3                   	ret    
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d55:	c9                   	leave  
80104d56:	c3                   	ret    
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <sys_write>:
80104d60:	55                   	push   %ebp
80104d61:	31 c0                	xor    %eax,%eax
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	83 ec 18             	sub    $0x18,%esp
80104d68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d6b:	e8 c0 fe ff ff       	call   80104c30 <argfd.constprop.0>
80104d70:	85 c0                	test   %eax,%eax
80104d72:	78 4c                	js     80104dc0 <sys_write+0x60>
80104d74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d77:	83 ec 08             	sub    $0x8,%esp
80104d7a:	50                   	push   %eax
80104d7b:	6a 02                	push   $0x2
80104d7d:	e8 be fb ff ff       	call   80104940 <argint>
80104d82:	83 c4 10             	add    $0x10,%esp
80104d85:	85 c0                	test   %eax,%eax
80104d87:	78 37                	js     80104dc0 <sys_write+0x60>
80104d89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d8c:	83 ec 04             	sub    $0x4,%esp
80104d8f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d92:	50                   	push   %eax
80104d93:	6a 01                	push   $0x1
80104d95:	e8 f6 fb ff ff       	call   80104990 <argptr>
80104d9a:	83 c4 10             	add    $0x10,%esp
80104d9d:	85 c0                	test   %eax,%eax
80104d9f:	78 1f                	js     80104dc0 <sys_write+0x60>
80104da1:	83 ec 04             	sub    $0x4,%esp
80104da4:	ff 75 f0             	pushl  -0x10(%ebp)
80104da7:	ff 75 f4             	pushl  -0xc(%ebp)
80104daa:	ff 75 ec             	pushl  -0x14(%ebp)
80104dad:	e8 3e c2 ff ff       	call   80100ff0 <filewrite>
80104db2:	83 c4 10             	add    $0x10,%esp
80104db5:	c9                   	leave  
80104db6:	c3                   	ret    
80104db7:	89 f6                	mov    %esi,%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	c9                   	leave  
80104dc6:	c3                   	ret    
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <sys_close>:
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 18             	sub    $0x18,%esp
80104dd6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104dd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ddc:	e8 4f fe ff ff       	call   80104c30 <argfd.constprop.0>
80104de1:	85 c0                	test   %eax,%eax
80104de3:	78 2b                	js     80104e10 <sys_close+0x40>
80104de5:	e8 66 ea ff ff       	call   80103850 <myproc>
80104dea:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ded:	83 ec 0c             	sub    $0xc,%esp
80104df0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104df7:	00 
80104df8:	ff 75 f4             	pushl  -0xc(%ebp)
80104dfb:	e8 40 c0 ff ff       	call   80100e40 <fileclose>
80104e00:	83 c4 10             	add    $0x10,%esp
80104e03:	31 c0                	xor    %eax,%eax
80104e05:	c9                   	leave  
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e15:	c9                   	leave  
80104e16:	c3                   	ret    
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <sys_fstat>:
80104e20:	55                   	push   %ebp
80104e21:	31 c0                	xor    %eax,%eax
80104e23:	89 e5                	mov    %esp,%ebp
80104e25:	83 ec 18             	sub    $0x18,%esp
80104e28:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e2b:	e8 00 fe ff ff       	call   80104c30 <argfd.constprop.0>
80104e30:	85 c0                	test   %eax,%eax
80104e32:	78 2c                	js     80104e60 <sys_fstat+0x40>
80104e34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e37:	83 ec 04             	sub    $0x4,%esp
80104e3a:	6a 14                	push   $0x14
80104e3c:	50                   	push   %eax
80104e3d:	6a 01                	push   $0x1
80104e3f:	e8 4c fb ff ff       	call   80104990 <argptr>
80104e44:	83 c4 10             	add    $0x10,%esp
80104e47:	85 c0                	test   %eax,%eax
80104e49:	78 15                	js     80104e60 <sys_fstat+0x40>
80104e4b:	83 ec 08             	sub    $0x8,%esp
80104e4e:	ff 75 f4             	pushl  -0xc(%ebp)
80104e51:	ff 75 f0             	pushl  -0x10(%ebp)
80104e54:	e8 b7 c0 ff ff       	call   80100f10 <filestat>
80104e59:	83 c4 10             	add    $0x10,%esp
80104e5c:	c9                   	leave  
80104e5d:	c3                   	ret    
80104e5e:	66 90                	xchg   %ax,%ax
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <sys_link>:
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	56                   	push   %esi
80104e75:	53                   	push   %ebx
80104e76:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104e79:	83 ec 34             	sub    $0x34,%esp
80104e7c:	50                   	push   %eax
80104e7d:	6a 00                	push   $0x0
80104e7f:	e8 6c fb ff ff       	call   801049f0 <argstr>
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	85 c0                	test   %eax,%eax
80104e89:	0f 88 fb 00 00 00    	js     80104f8a <sys_link+0x11a>
80104e8f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e92:	83 ec 08             	sub    $0x8,%esp
80104e95:	50                   	push   %eax
80104e96:	6a 01                	push   $0x1
80104e98:	e8 53 fb ff ff       	call   801049f0 <argstr>
80104e9d:	83 c4 10             	add    $0x10,%esp
80104ea0:	85 c0                	test   %eax,%eax
80104ea2:	0f 88 e2 00 00 00    	js     80104f8a <sys_link+0x11a>
80104ea8:	e8 f3 dc ff ff       	call   80102ba0 <begin_op>
80104ead:	83 ec 0c             	sub    $0xc,%esp
80104eb0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104eb3:	e8 28 d0 ff ff       	call   80101ee0 <namei>
80104eb8:	83 c4 10             	add    $0x10,%esp
80104ebb:	85 c0                	test   %eax,%eax
80104ebd:	89 c3                	mov    %eax,%ebx
80104ebf:	0f 84 ea 00 00 00    	je     80104faf <sys_link+0x13f>
80104ec5:	83 ec 0c             	sub    $0xc,%esp
80104ec8:	50                   	push   %eax
80104ec9:	e8 b2 c7 ff ff       	call   80101680 <ilock>
80104ece:	83 c4 10             	add    $0x10,%esp
80104ed1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ed6:	0f 84 bb 00 00 00    	je     80104f97 <sys_link+0x127>
80104edc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
80104ee1:	83 ec 0c             	sub    $0xc,%esp
80104ee4:	8d 7d da             	lea    -0x26(%ebp),%edi
80104ee7:	53                   	push   %ebx
80104ee8:	e8 e3 c6 ff ff       	call   801015d0 <iupdate>
80104eed:	89 1c 24             	mov    %ebx,(%esp)
80104ef0:	e8 6b c8 ff ff       	call   80101760 <iunlock>
80104ef5:	58                   	pop    %eax
80104ef6:	5a                   	pop    %edx
80104ef7:	57                   	push   %edi
80104ef8:	ff 75 d0             	pushl  -0x30(%ebp)
80104efb:	e8 00 d0 ff ff       	call   80101f00 <nameiparent>
80104f00:	83 c4 10             	add    $0x10,%esp
80104f03:	85 c0                	test   %eax,%eax
80104f05:	89 c6                	mov    %eax,%esi
80104f07:	74 5b                	je     80104f64 <sys_link+0xf4>
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	50                   	push   %eax
80104f0d:	e8 6e c7 ff ff       	call   80101680 <ilock>
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	8b 03                	mov    (%ebx),%eax
80104f17:	39 06                	cmp    %eax,(%esi)
80104f19:	75 3d                	jne    80104f58 <sys_link+0xe8>
80104f1b:	83 ec 04             	sub    $0x4,%esp
80104f1e:	ff 73 04             	pushl  0x4(%ebx)
80104f21:	57                   	push   %edi
80104f22:	56                   	push   %esi
80104f23:	e8 f8 ce ff ff       	call   80101e20 <dirlink>
80104f28:	83 c4 10             	add    $0x10,%esp
80104f2b:	85 c0                	test   %eax,%eax
80104f2d:	78 29                	js     80104f58 <sys_link+0xe8>
80104f2f:	83 ec 0c             	sub    $0xc,%esp
80104f32:	56                   	push   %esi
80104f33:	e8 d8 c9 ff ff       	call   80101910 <iunlockput>
80104f38:	89 1c 24             	mov    %ebx,(%esp)
80104f3b:	e8 70 c8 ff ff       	call   801017b0 <iput>
80104f40:	e8 cb dc ff ff       	call   80102c10 <end_op>
80104f45:	83 c4 10             	add    $0x10,%esp
80104f48:	31 c0                	xor    %eax,%eax
80104f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f4d:	5b                   	pop    %ebx
80104f4e:	5e                   	pop    %esi
80104f4f:	5f                   	pop    %edi
80104f50:	5d                   	pop    %ebp
80104f51:	c3                   	ret    
80104f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f58:	83 ec 0c             	sub    $0xc,%esp
80104f5b:	56                   	push   %esi
80104f5c:	e8 af c9 ff ff       	call   80101910 <iunlockput>
80104f61:	83 c4 10             	add    $0x10,%esp
80104f64:	83 ec 0c             	sub    $0xc,%esp
80104f67:	53                   	push   %ebx
80104f68:	e8 13 c7 ff ff       	call   80101680 <ilock>
80104f6d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80104f72:	89 1c 24             	mov    %ebx,(%esp)
80104f75:	e8 56 c6 ff ff       	call   801015d0 <iupdate>
80104f7a:	89 1c 24             	mov    %ebx,(%esp)
80104f7d:	e8 8e c9 ff ff       	call   80101910 <iunlockput>
80104f82:	e8 89 dc ff ff       	call   80102c10 <end_op>
80104f87:	83 c4 10             	add    $0x10,%esp
80104f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f92:	5b                   	pop    %ebx
80104f93:	5e                   	pop    %esi
80104f94:	5f                   	pop    %edi
80104f95:	5d                   	pop    %ebp
80104f96:	c3                   	ret    
80104f97:	83 ec 0c             	sub    $0xc,%esp
80104f9a:	53                   	push   %ebx
80104f9b:	e8 70 c9 ff ff       	call   80101910 <iunlockput>
80104fa0:	e8 6b dc ff ff       	call   80102c10 <end_op>
80104fa5:	83 c4 10             	add    $0x10,%esp
80104fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fad:	eb 9b                	jmp    80104f4a <sys_link+0xda>
80104faf:	e8 5c dc ff ff       	call   80102c10 <end_op>
80104fb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fb9:	eb 8f                	jmp    80104f4a <sys_link+0xda>
80104fbb:	90                   	nop
80104fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fc0 <sys_unlink>:
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	57                   	push   %edi
80104fc4:	56                   	push   %esi
80104fc5:	53                   	push   %ebx
80104fc6:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104fc9:	83 ec 44             	sub    $0x44,%esp
80104fcc:	50                   	push   %eax
80104fcd:	6a 00                	push   $0x0
80104fcf:	e8 1c fa ff ff       	call   801049f0 <argstr>
80104fd4:	83 c4 10             	add    $0x10,%esp
80104fd7:	85 c0                	test   %eax,%eax
80104fd9:	0f 88 77 01 00 00    	js     80105156 <sys_unlink+0x196>
80104fdf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104fe2:	e8 b9 db ff ff       	call   80102ba0 <begin_op>
80104fe7:	83 ec 08             	sub    $0x8,%esp
80104fea:	53                   	push   %ebx
80104feb:	ff 75 c0             	pushl  -0x40(%ebp)
80104fee:	e8 0d cf ff ff       	call   80101f00 <nameiparent>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	89 c6                	mov    %eax,%esi
80104ffa:	0f 84 60 01 00 00    	je     80105160 <sys_unlink+0x1a0>
80105000:	83 ec 0c             	sub    $0xc,%esp
80105003:	50                   	push   %eax
80105004:	e8 77 c6 ff ff       	call   80101680 <ilock>
80105009:	58                   	pop    %eax
8010500a:	5a                   	pop    %edx
8010500b:	68 78 78 10 80       	push   $0x80107878
80105010:	53                   	push   %ebx
80105011:	e8 7a cb ff ff       	call   80101b90 <namecmp>
80105016:	83 c4 10             	add    $0x10,%esp
80105019:	85 c0                	test   %eax,%eax
8010501b:	0f 84 03 01 00 00    	je     80105124 <sys_unlink+0x164>
80105021:	83 ec 08             	sub    $0x8,%esp
80105024:	68 77 78 10 80       	push   $0x80107877
80105029:	53                   	push   %ebx
8010502a:	e8 61 cb ff ff       	call   80101b90 <namecmp>
8010502f:	83 c4 10             	add    $0x10,%esp
80105032:	85 c0                	test   %eax,%eax
80105034:	0f 84 ea 00 00 00    	je     80105124 <sys_unlink+0x164>
8010503a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010503d:	83 ec 04             	sub    $0x4,%esp
80105040:	50                   	push   %eax
80105041:	53                   	push   %ebx
80105042:	56                   	push   %esi
80105043:	e8 68 cb ff ff       	call   80101bb0 <dirlookup>
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	85 c0                	test   %eax,%eax
8010504d:	89 c3                	mov    %eax,%ebx
8010504f:	0f 84 cf 00 00 00    	je     80105124 <sys_unlink+0x164>
80105055:	83 ec 0c             	sub    $0xc,%esp
80105058:	50                   	push   %eax
80105059:	e8 22 c6 ff ff       	call   80101680 <ilock>
8010505e:	83 c4 10             	add    $0x10,%esp
80105061:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105066:	0f 8e 10 01 00 00    	jle    8010517c <sys_unlink+0x1bc>
8010506c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105071:	74 6d                	je     801050e0 <sys_unlink+0x120>
80105073:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105076:	83 ec 04             	sub    $0x4,%esp
80105079:	6a 10                	push   $0x10
8010507b:	6a 00                	push   $0x0
8010507d:	50                   	push   %eax
8010507e:	e8 bd f5 ff ff       	call   80104640 <memset>
80105083:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105086:	6a 10                	push   $0x10
80105088:	ff 75 c4             	pushl  -0x3c(%ebp)
8010508b:	50                   	push   %eax
8010508c:	56                   	push   %esi
8010508d:	e8 ce c9 ff ff       	call   80101a60 <writei>
80105092:	83 c4 20             	add    $0x20,%esp
80105095:	83 f8 10             	cmp    $0x10,%eax
80105098:	0f 85 eb 00 00 00    	jne    80105189 <sys_unlink+0x1c9>
8010509e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050a3:	0f 84 97 00 00 00    	je     80105140 <sys_unlink+0x180>
801050a9:	83 ec 0c             	sub    $0xc,%esp
801050ac:	56                   	push   %esi
801050ad:	e8 5e c8 ff ff       	call   80101910 <iunlockput>
801050b2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
801050b7:	89 1c 24             	mov    %ebx,(%esp)
801050ba:	e8 11 c5 ff ff       	call   801015d0 <iupdate>
801050bf:	89 1c 24             	mov    %ebx,(%esp)
801050c2:	e8 49 c8 ff ff       	call   80101910 <iunlockput>
801050c7:	e8 44 db ff ff       	call   80102c10 <end_op>
801050cc:	83 c4 10             	add    $0x10,%esp
801050cf:	31 c0                	xor    %eax,%eax
801050d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050d4:	5b                   	pop    %ebx
801050d5:	5e                   	pop    %esi
801050d6:	5f                   	pop    %edi
801050d7:	5d                   	pop    %ebp
801050d8:	c3                   	ret    
801050d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801050e4:	76 8d                	jbe    80105073 <sys_unlink+0xb3>
801050e6:	bf 20 00 00 00       	mov    $0x20,%edi
801050eb:	eb 0f                	jmp    801050fc <sys_unlink+0x13c>
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
801050f0:	83 c7 10             	add    $0x10,%edi
801050f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801050f6:	0f 83 77 ff ff ff    	jae    80105073 <sys_unlink+0xb3>
801050fc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801050ff:	6a 10                	push   $0x10
80105101:	57                   	push   %edi
80105102:	50                   	push   %eax
80105103:	53                   	push   %ebx
80105104:	e8 57 c8 ff ff       	call   80101960 <readi>
80105109:	83 c4 10             	add    $0x10,%esp
8010510c:	83 f8 10             	cmp    $0x10,%eax
8010510f:	75 5e                	jne    8010516f <sys_unlink+0x1af>
80105111:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105116:	74 d8                	je     801050f0 <sys_unlink+0x130>
80105118:	83 ec 0c             	sub    $0xc,%esp
8010511b:	53                   	push   %ebx
8010511c:	e8 ef c7 ff ff       	call   80101910 <iunlockput>
80105121:	83 c4 10             	add    $0x10,%esp
80105124:	83 ec 0c             	sub    $0xc,%esp
80105127:	56                   	push   %esi
80105128:	e8 e3 c7 ff ff       	call   80101910 <iunlockput>
8010512d:	e8 de da ff ff       	call   80102c10 <end_op>
80105132:	83 c4 10             	add    $0x10,%esp
80105135:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513a:	eb 95                	jmp    801050d1 <sys_unlink+0x111>
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105140:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
80105145:	83 ec 0c             	sub    $0xc,%esp
80105148:	56                   	push   %esi
80105149:	e8 82 c4 ff ff       	call   801015d0 <iupdate>
8010514e:	83 c4 10             	add    $0x10,%esp
80105151:	e9 53 ff ff ff       	jmp    801050a9 <sys_unlink+0xe9>
80105156:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010515b:	e9 71 ff ff ff       	jmp    801050d1 <sys_unlink+0x111>
80105160:	e8 ab da ff ff       	call   80102c10 <end_op>
80105165:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516a:	e9 62 ff ff ff       	jmp    801050d1 <sys_unlink+0x111>
8010516f:	83 ec 0c             	sub    $0xc,%esp
80105172:	68 9c 78 10 80       	push   $0x8010789c
80105177:	e8 14 b2 ff ff       	call   80100390 <panic>
8010517c:	83 ec 0c             	sub    $0xc,%esp
8010517f:	68 8a 78 10 80       	push   $0x8010788a
80105184:	e8 07 b2 ff ff       	call   80100390 <panic>
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	68 ae 78 10 80       	push   $0x801078ae
80105191:	e8 fa b1 ff ff       	call   80100390 <panic>
80105196:	8d 76 00             	lea    0x0(%esi),%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051a0 <sys_open>:
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	56                   	push   %esi
801051a5:	53                   	push   %ebx
801051a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801051a9:	83 ec 24             	sub    $0x24,%esp
801051ac:	50                   	push   %eax
801051ad:	6a 00                	push   $0x0
801051af:	e8 3c f8 ff ff       	call   801049f0 <argstr>
801051b4:	83 c4 10             	add    $0x10,%esp
801051b7:	85 c0                	test   %eax,%eax
801051b9:	0f 88 1d 01 00 00    	js     801052dc <sys_open+0x13c>
801051bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801051c2:	83 ec 08             	sub    $0x8,%esp
801051c5:	50                   	push   %eax
801051c6:	6a 01                	push   $0x1
801051c8:	e8 73 f7 ff ff       	call   80104940 <argint>
801051cd:	83 c4 10             	add    $0x10,%esp
801051d0:	85 c0                	test   %eax,%eax
801051d2:	0f 88 04 01 00 00    	js     801052dc <sys_open+0x13c>
801051d8:	e8 c3 d9 ff ff       	call   80102ba0 <begin_op>
801051dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801051e1:	0f 85 a9 00 00 00    	jne    80105290 <sys_open+0xf0>
801051e7:	83 ec 0c             	sub    $0xc,%esp
801051ea:	ff 75 e0             	pushl  -0x20(%ebp)
801051ed:	e8 ee cc ff ff       	call   80101ee0 <namei>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	89 c6                	mov    %eax,%esi
801051f9:	0f 84 b2 00 00 00    	je     801052b1 <sys_open+0x111>
801051ff:	83 ec 0c             	sub    $0xc,%esp
80105202:	50                   	push   %eax
80105203:	e8 78 c4 ff ff       	call   80101680 <ilock>
80105208:	83 c4 10             	add    $0x10,%esp
8010520b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105210:	0f 84 aa 00 00 00    	je     801052c0 <sys_open+0x120>
80105216:	e8 65 bb ff ff       	call   80100d80 <filealloc>
8010521b:	85 c0                	test   %eax,%eax
8010521d:	89 c7                	mov    %eax,%edi
8010521f:	0f 84 a6 00 00 00    	je     801052cb <sys_open+0x12b>
80105225:	e8 26 e6 ff ff       	call   80103850 <myproc>
8010522a:	31 db                	xor    %ebx,%ebx
8010522c:	eb 0e                	jmp    8010523c <sys_open+0x9c>
8010522e:	66 90                	xchg   %ax,%ax
80105230:	83 c3 01             	add    $0x1,%ebx
80105233:	83 fb 10             	cmp    $0x10,%ebx
80105236:	0f 84 ac 00 00 00    	je     801052e8 <sys_open+0x148>
8010523c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105240:	85 d2                	test   %edx,%edx
80105242:	75 ec                	jne    80105230 <sys_open+0x90>
80105244:	83 ec 0c             	sub    $0xc,%esp
80105247:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
8010524b:	56                   	push   %esi
8010524c:	e8 0f c5 ff ff       	call   80101760 <iunlock>
80105251:	e8 ba d9 ff ff       	call   80102c10 <end_op>
80105256:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
8010525c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010525f:	83 c4 10             	add    $0x10,%esp
80105262:	89 77 10             	mov    %esi,0x10(%edi)
80105265:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
8010526c:	89 d0                	mov    %edx,%eax
8010526e:	f7 d0                	not    %eax
80105270:	83 e0 01             	and    $0x1,%eax
80105273:	83 e2 03             	and    $0x3,%edx
80105276:	88 47 08             	mov    %al,0x8(%edi)
80105279:	0f 95 47 09          	setne  0x9(%edi)
8010527d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105280:	89 d8                	mov    %ebx,%eax
80105282:	5b                   	pop    %ebx
80105283:	5e                   	pop    %esi
80105284:	5f                   	pop    %edi
80105285:	5d                   	pop    %ebp
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105290:	83 ec 0c             	sub    $0xc,%esp
80105293:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105296:	31 c9                	xor    %ecx,%ecx
80105298:	6a 00                	push   $0x0
8010529a:	ba 02 00 00 00       	mov    $0x2,%edx
8010529f:	e8 ec f7 ff ff       	call   80104a90 <create>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	89 c6                	mov    %eax,%esi
801052ab:	0f 85 65 ff ff ff    	jne    80105216 <sys_open+0x76>
801052b1:	e8 5a d9 ff ff       	call   80102c10 <end_op>
801052b6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052bb:	eb c0                	jmp    8010527d <sys_open+0xdd>
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
801052c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801052c3:	85 c9                	test   %ecx,%ecx
801052c5:	0f 84 4b ff ff ff    	je     80105216 <sys_open+0x76>
801052cb:	83 ec 0c             	sub    $0xc,%esp
801052ce:	56                   	push   %esi
801052cf:	e8 3c c6 ff ff       	call   80101910 <iunlockput>
801052d4:	e8 37 d9 ff ff       	call   80102c10 <end_op>
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052e1:	eb 9a                	jmp    8010527d <sys_open+0xdd>
801052e3:	90                   	nop
801052e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052e8:	83 ec 0c             	sub    $0xc,%esp
801052eb:	57                   	push   %edi
801052ec:	e8 4f bb ff ff       	call   80100e40 <fileclose>
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	eb d5                	jmp    801052cb <sys_open+0x12b>
801052f6:	8d 76 00             	lea    0x0(%esi),%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <sys_mkdir>:
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 18             	sub    $0x18,%esp
80105306:	e8 95 d8 ff ff       	call   80102ba0 <begin_op>
8010530b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010530e:	83 ec 08             	sub    $0x8,%esp
80105311:	50                   	push   %eax
80105312:	6a 00                	push   $0x0
80105314:	e8 d7 f6 ff ff       	call   801049f0 <argstr>
80105319:	83 c4 10             	add    $0x10,%esp
8010531c:	85 c0                	test   %eax,%eax
8010531e:	78 30                	js     80105350 <sys_mkdir+0x50>
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105326:	31 c9                	xor    %ecx,%ecx
80105328:	6a 00                	push   $0x0
8010532a:	ba 01 00 00 00       	mov    $0x1,%edx
8010532f:	e8 5c f7 ff ff       	call   80104a90 <create>
80105334:	83 c4 10             	add    $0x10,%esp
80105337:	85 c0                	test   %eax,%eax
80105339:	74 15                	je     80105350 <sys_mkdir+0x50>
8010533b:	83 ec 0c             	sub    $0xc,%esp
8010533e:	50                   	push   %eax
8010533f:	e8 cc c5 ff ff       	call   80101910 <iunlockput>
80105344:	e8 c7 d8 ff ff       	call   80102c10 <end_op>
80105349:	83 c4 10             	add    $0x10,%esp
8010534c:	31 c0                	xor    %eax,%eax
8010534e:	c9                   	leave  
8010534f:	c3                   	ret    
80105350:	e8 bb d8 ff ff       	call   80102c10 <end_op>
80105355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535a:	c9                   	leave  
8010535b:	c3                   	ret    
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_mknod>:
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	83 ec 18             	sub    $0x18,%esp
80105366:	e8 35 d8 ff ff       	call   80102ba0 <begin_op>
8010536b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010536e:	83 ec 08             	sub    $0x8,%esp
80105371:	50                   	push   %eax
80105372:	6a 00                	push   $0x0
80105374:	e8 77 f6 ff ff       	call   801049f0 <argstr>
80105379:	83 c4 10             	add    $0x10,%esp
8010537c:	85 c0                	test   %eax,%eax
8010537e:	78 60                	js     801053e0 <sys_mknod+0x80>
80105380:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105383:	83 ec 08             	sub    $0x8,%esp
80105386:	50                   	push   %eax
80105387:	6a 01                	push   $0x1
80105389:	e8 b2 f5 ff ff       	call   80104940 <argint>
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	85 c0                	test   %eax,%eax
80105393:	78 4b                	js     801053e0 <sys_mknod+0x80>
80105395:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105398:	83 ec 08             	sub    $0x8,%esp
8010539b:	50                   	push   %eax
8010539c:	6a 02                	push   $0x2
8010539e:	e8 9d f5 ff ff       	call   80104940 <argint>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	78 36                	js     801053e0 <sys_mknod+0x80>
801053aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801053ae:	83 ec 0c             	sub    $0xc,%esp
801053b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801053b5:	ba 03 00 00 00       	mov    $0x3,%edx
801053ba:	50                   	push   %eax
801053bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053be:	e8 cd f6 ff ff       	call   80104a90 <create>
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	85 c0                	test   %eax,%eax
801053c8:	74 16                	je     801053e0 <sys_mknod+0x80>
801053ca:	83 ec 0c             	sub    $0xc,%esp
801053cd:	50                   	push   %eax
801053ce:	e8 3d c5 ff ff       	call   80101910 <iunlockput>
801053d3:	e8 38 d8 ff ff       	call   80102c10 <end_op>
801053d8:	83 c4 10             	add    $0x10,%esp
801053db:	31 c0                	xor    %eax,%eax
801053dd:	c9                   	leave  
801053de:	c3                   	ret    
801053df:	90                   	nop
801053e0:	e8 2b d8 ff ff       	call   80102c10 <end_op>
801053e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ea:	c9                   	leave  
801053eb:	c3                   	ret    
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_chdir>:
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	56                   	push   %esi
801053f4:	53                   	push   %ebx
801053f5:	83 ec 10             	sub    $0x10,%esp
801053f8:	e8 53 e4 ff ff       	call   80103850 <myproc>
801053fd:	89 c6                	mov    %eax,%esi
801053ff:	e8 9c d7 ff ff       	call   80102ba0 <begin_op>
80105404:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105407:	83 ec 08             	sub    $0x8,%esp
8010540a:	50                   	push   %eax
8010540b:	6a 00                	push   $0x0
8010540d:	e8 de f5 ff ff       	call   801049f0 <argstr>
80105412:	83 c4 10             	add    $0x10,%esp
80105415:	85 c0                	test   %eax,%eax
80105417:	78 77                	js     80105490 <sys_chdir+0xa0>
80105419:	83 ec 0c             	sub    $0xc,%esp
8010541c:	ff 75 f4             	pushl  -0xc(%ebp)
8010541f:	e8 bc ca ff ff       	call   80101ee0 <namei>
80105424:	83 c4 10             	add    $0x10,%esp
80105427:	85 c0                	test   %eax,%eax
80105429:	89 c3                	mov    %eax,%ebx
8010542b:	74 63                	je     80105490 <sys_chdir+0xa0>
8010542d:	83 ec 0c             	sub    $0xc,%esp
80105430:	50                   	push   %eax
80105431:	e8 4a c2 ff ff       	call   80101680 <ilock>
80105436:	83 c4 10             	add    $0x10,%esp
80105439:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010543e:	75 30                	jne    80105470 <sys_chdir+0x80>
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	53                   	push   %ebx
80105444:	e8 17 c3 ff ff       	call   80101760 <iunlock>
80105449:	58                   	pop    %eax
8010544a:	ff 76 68             	pushl  0x68(%esi)
8010544d:	e8 5e c3 ff ff       	call   801017b0 <iput>
80105452:	e8 b9 d7 ff ff       	call   80102c10 <end_op>
80105457:	89 5e 68             	mov    %ebx,0x68(%esi)
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	31 c0                	xor    %eax,%eax
8010545f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105462:	5b                   	pop    %ebx
80105463:	5e                   	pop    %esi
80105464:	5d                   	pop    %ebp
80105465:	c3                   	ret    
80105466:	8d 76 00             	lea    0x0(%esi),%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	53                   	push   %ebx
80105474:	e8 97 c4 ff ff       	call   80101910 <iunlockput>
80105479:	e8 92 d7 ff ff       	call   80102c10 <end_op>
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105486:	eb d7                	jmp    8010545f <sys_chdir+0x6f>
80105488:	90                   	nop
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105490:	e8 7b d7 ff ff       	call   80102c10 <end_op>
80105495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549a:	eb c3                	jmp    8010545f <sys_chdir+0x6f>
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_exec>:
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
801054a5:	53                   	push   %ebx
801054a6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801054ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
801054b2:	50                   	push   %eax
801054b3:	6a 00                	push   $0x0
801054b5:	e8 36 f5 ff ff       	call   801049f0 <argstr>
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	85 c0                	test   %eax,%eax
801054bf:	0f 88 87 00 00 00    	js     8010554c <sys_exec+0xac>
801054c5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801054cb:	83 ec 08             	sub    $0x8,%esp
801054ce:	50                   	push   %eax
801054cf:	6a 01                	push   $0x1
801054d1:	e8 6a f4 ff ff       	call   80104940 <argint>
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	85 c0                	test   %eax,%eax
801054db:	78 6f                	js     8010554c <sys_exec+0xac>
801054dd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801054e3:	83 ec 04             	sub    $0x4,%esp
801054e6:	31 db                	xor    %ebx,%ebx
801054e8:	68 80 00 00 00       	push   $0x80
801054ed:	6a 00                	push   $0x0
801054ef:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801054f5:	50                   	push   %eax
801054f6:	e8 45 f1 ff ff       	call   80104640 <memset>
801054fb:	83 c4 10             	add    $0x10,%esp
801054fe:	eb 2c                	jmp    8010552c <sys_exec+0x8c>
80105500:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105506:	85 c0                	test   %eax,%eax
80105508:	74 56                	je     80105560 <sys_exec+0xc0>
8010550a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105510:	83 ec 08             	sub    $0x8,%esp
80105513:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105516:	52                   	push   %edx
80105517:	50                   	push   %eax
80105518:	e8 b3 f3 ff ff       	call   801048d0 <fetchstr>
8010551d:	83 c4 10             	add    $0x10,%esp
80105520:	85 c0                	test   %eax,%eax
80105522:	78 28                	js     8010554c <sys_exec+0xac>
80105524:	83 c3 01             	add    $0x1,%ebx
80105527:	83 fb 20             	cmp    $0x20,%ebx
8010552a:	74 20                	je     8010554c <sys_exec+0xac>
8010552c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105532:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105539:	83 ec 08             	sub    $0x8,%esp
8010553c:	57                   	push   %edi
8010553d:	01 f0                	add    %esi,%eax
8010553f:	50                   	push   %eax
80105540:	e8 4b f3 ff ff       	call   80104890 <fetchint>
80105545:	83 c4 10             	add    $0x10,%esp
80105548:	85 c0                	test   %eax,%eax
8010554a:	79 b4                	jns    80105500 <sys_exec+0x60>
8010554c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010554f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105554:	5b                   	pop    %ebx
80105555:	5e                   	pop    %esi
80105556:	5f                   	pop    %edi
80105557:	5d                   	pop    %ebp
80105558:	c3                   	ret    
80105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105560:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105566:	83 ec 08             	sub    $0x8,%esp
80105569:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105570:	00 00 00 00 
80105574:	50                   	push   %eax
80105575:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010557b:	e8 90 b4 ff ff       	call   80100a10 <exec>
80105580:	83 c4 10             	add    $0x10,%esp
80105583:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105586:	5b                   	pop    %ebx
80105587:	5e                   	pop    %esi
80105588:	5f                   	pop    %edi
80105589:	5d                   	pop    %ebp
8010558a:	c3                   	ret    
8010558b:	90                   	nop
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_pipe>:
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
80105595:	53                   	push   %ebx
80105596:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105599:	83 ec 20             	sub    $0x20,%esp
8010559c:	6a 08                	push   $0x8
8010559e:	50                   	push   %eax
8010559f:	6a 00                	push   $0x0
801055a1:	e8 ea f3 ff ff       	call   80104990 <argptr>
801055a6:	83 c4 10             	add    $0x10,%esp
801055a9:	85 c0                	test   %eax,%eax
801055ab:	0f 88 ae 00 00 00    	js     8010565f <sys_pipe+0xcf>
801055b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055b4:	83 ec 08             	sub    $0x8,%esp
801055b7:	50                   	push   %eax
801055b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801055bb:	50                   	push   %eax
801055bc:	e8 7f dc ff ff       	call   80103240 <pipealloc>
801055c1:	83 c4 10             	add    $0x10,%esp
801055c4:	85 c0                	test   %eax,%eax
801055c6:	0f 88 93 00 00 00    	js     8010565f <sys_pipe+0xcf>
801055cc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801055cf:	31 db                	xor    %ebx,%ebx
801055d1:	e8 7a e2 ff ff       	call   80103850 <myproc>
801055d6:	eb 10                	jmp    801055e8 <sys_pipe+0x58>
801055d8:	90                   	nop
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055e0:	83 c3 01             	add    $0x1,%ebx
801055e3:	83 fb 10             	cmp    $0x10,%ebx
801055e6:	74 60                	je     80105648 <sys_pipe+0xb8>
801055e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801055ec:	85 f6                	test   %esi,%esi
801055ee:	75 f0                	jne    801055e0 <sys_pipe+0x50>
801055f0:	8d 73 08             	lea    0x8(%ebx),%esi
801055f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
801055f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801055fa:	e8 51 e2 ff ff       	call   80103850 <myproc>
801055ff:	31 d2                	xor    %edx,%edx
80105601:	eb 0d                	jmp    80105610 <sys_pipe+0x80>
80105603:	90                   	nop
80105604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105608:	83 c2 01             	add    $0x1,%edx
8010560b:	83 fa 10             	cmp    $0x10,%edx
8010560e:	74 28                	je     80105638 <sys_pipe+0xa8>
80105610:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105614:	85 c9                	test   %ecx,%ecx
80105616:	75 f0                	jne    80105608 <sys_pipe+0x78>
80105618:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
8010561c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010561f:	89 18                	mov    %ebx,(%eax)
80105621:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105624:	89 50 04             	mov    %edx,0x4(%eax)
80105627:	31 c0                	xor    %eax,%eax
80105629:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010562c:	5b                   	pop    %ebx
8010562d:	5e                   	pop    %esi
8010562e:	5f                   	pop    %edi
8010562f:	5d                   	pop    %ebp
80105630:	c3                   	ret    
80105631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105638:	e8 13 e2 ff ff       	call   80103850 <myproc>
8010563d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105644:	00 
80105645:	8d 76 00             	lea    0x0(%esi),%esi
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	ff 75 e0             	pushl  -0x20(%ebp)
8010564e:	e8 ed b7 ff ff       	call   80100e40 <fileclose>
80105653:	58                   	pop    %eax
80105654:	ff 75 e4             	pushl  -0x1c(%ebp)
80105657:	e8 e4 b7 ff ff       	call   80100e40 <fileclose>
8010565c:	83 c4 10             	add    $0x10,%esp
8010565f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105664:	eb c3                	jmp    80105629 <sys_pipe+0x99>
80105666:	66 90                	xchg   %ax,%ax
80105668:	66 90                	xchg   %ax,%ax
8010566a:	66 90                	xchg   %ax,%ax
8010566c:	66 90                	xchg   %ax,%ax
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_fork>:
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	5d                   	pop    %ebp
80105674:	e9 77 e3 ff ff       	jmp    801039f0 <fork>
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_exit>:
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 08             	sub    $0x8,%esp
80105686:	e8 15 e6 ff ff       	call   80103ca0 <exit>
8010568b:	31 c0                	xor    %eax,%eax
8010568d:	c9                   	leave  
8010568e:	c3                   	ret    
8010568f:	90                   	nop

80105690 <sys_wait>:
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	5d                   	pop    %ebp
80105694:	e9 57 e8 ff ff       	jmp    80103ef0 <wait>
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_waitx>:
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 1c             	sub    $0x1c,%esp
801056a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056a9:	6a 04                	push   $0x4
801056ab:	50                   	push   %eax
801056ac:	6a 00                	push   $0x0
801056ae:	e8 dd f2 ff ff       	call   80104990 <argptr>
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	85 c0                	test   %eax,%eax
801056b8:	78 2e                	js     801056e8 <sys_waitx+0x48>
801056ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056bd:	83 ec 04             	sub    $0x4,%esp
801056c0:	6a 04                	push   $0x4
801056c2:	50                   	push   %eax
801056c3:	6a 01                	push   $0x1
801056c5:	e8 c6 f2 ff ff       	call   80104990 <argptr>
801056ca:	83 c4 10             	add    $0x10,%esp
801056cd:	85 c0                	test   %eax,%eax
801056cf:	78 17                	js     801056e8 <sys_waitx+0x48>
801056d1:	83 ec 08             	sub    $0x8,%esp
801056d4:	ff 75 f4             	pushl  -0xc(%ebp)
801056d7:	ff 75 f0             	pushl  -0x10(%ebp)
801056da:	e8 c1 ea ff ff       	call   801041a0 <waitx>
801056df:	83 c4 10             	add    $0x10,%esp
801056e2:	c9                   	leave  
801056e3:	c3                   	ret    
801056e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ed:	c9                   	leave  
801056ee:	c3                   	ret    
801056ef:	90                   	nop

801056f0 <sys_kill>:
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	83 ec 20             	sub    $0x20,%esp
801056f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056f9:	50                   	push   %eax
801056fa:	6a 00                	push   $0x0
801056fc:	e8 3f f2 ff ff       	call   80104940 <argint>
80105701:	83 c4 10             	add    $0x10,%esp
80105704:	85 c0                	test   %eax,%eax
80105706:	78 18                	js     80105720 <sys_kill+0x30>
80105708:	83 ec 0c             	sub    $0xc,%esp
8010570b:	ff 75 f4             	pushl  -0xc(%ebp)
8010570e:	e8 3d e9 ff ff       	call   80104050 <kill>
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	c9                   	leave  
80105717:	c3                   	ret    
80105718:	90                   	nop
80105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105725:	c9                   	leave  
80105726:	c3                   	ret    
80105727:	89 f6                	mov    %esi,%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_getpid>:
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 08             	sub    $0x8,%esp
80105736:	e8 15 e1 ff ff       	call   80103850 <myproc>
8010573b:	8b 40 10             	mov    0x10(%eax),%eax
8010573e:	c9                   	leave  
8010573f:	c3                   	ret    

80105740 <sys_sbrk>:
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	53                   	push   %ebx
80105744:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105747:	83 ec 1c             	sub    $0x1c,%esp
8010574a:	50                   	push   %eax
8010574b:	6a 00                	push   $0x0
8010574d:	e8 ee f1 ff ff       	call   80104940 <argint>
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	85 c0                	test   %eax,%eax
80105757:	78 27                	js     80105780 <sys_sbrk+0x40>
80105759:	e8 f2 e0 ff ff       	call   80103850 <myproc>
8010575e:	83 ec 0c             	sub    $0xc,%esp
80105761:	8b 18                	mov    (%eax),%ebx
80105763:	ff 75 f4             	pushl  -0xc(%ebp)
80105766:	e8 05 e2 ff ff       	call   80103970 <growproc>
8010576b:	83 c4 10             	add    $0x10,%esp
8010576e:	85 c0                	test   %eax,%eax
80105770:	78 0e                	js     80105780 <sys_sbrk+0x40>
80105772:	89 d8                	mov    %ebx,%eax
80105774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105777:	c9                   	leave  
80105778:	c3                   	ret    
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105780:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105785:	eb eb                	jmp    80105772 <sys_sbrk+0x32>
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <sys_sleep>:
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	53                   	push   %ebx
80105794:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105797:	83 ec 1c             	sub    $0x1c,%esp
8010579a:	50                   	push   %eax
8010579b:	6a 00                	push   $0x0
8010579d:	e8 9e f1 ff ff       	call   80104940 <argint>
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	85 c0                	test   %eax,%eax
801057a7:	0f 88 8a 00 00 00    	js     80105837 <sys_sleep+0xa7>
801057ad:	83 ec 0c             	sub    $0xc,%esp
801057b0:	68 60 50 11 80       	push   $0x80115060
801057b5:	e8 76 ed ff ff       	call   80104530 <acquire>
801057ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
801057c6:	85 d2                	test   %edx,%edx
801057c8:	75 27                	jne    801057f1 <sys_sleep+0x61>
801057ca:	eb 54                	jmp    80105820 <sys_sleep+0x90>
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057d0:	83 ec 08             	sub    $0x8,%esp
801057d3:	68 60 50 11 80       	push   $0x80115060
801057d8:	68 a0 58 11 80       	push   $0x801158a0
801057dd:	e8 4e e6 ff ff       	call   80103e30 <sleep>
801057e2:	a1 a0 58 11 80       	mov    0x801158a0,%eax
801057e7:	83 c4 10             	add    $0x10,%esp
801057ea:	29 d8                	sub    %ebx,%eax
801057ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801057ef:	73 2f                	jae    80105820 <sys_sleep+0x90>
801057f1:	e8 5a e0 ff ff       	call   80103850 <myproc>
801057f6:	8b 40 24             	mov    0x24(%eax),%eax
801057f9:	85 c0                	test   %eax,%eax
801057fb:	74 d3                	je     801057d0 <sys_sleep+0x40>
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	68 60 50 11 80       	push   $0x80115060
80105805:	e8 e6 ed ff ff       	call   801045f0 <release>
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105815:	c9                   	leave  
80105816:	c3                   	ret    
80105817:	89 f6                	mov    %esi,%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	68 60 50 11 80       	push   $0x80115060
80105828:	e8 c3 ed ff ff       	call   801045f0 <release>
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	31 c0                	xor    %eax,%eax
80105832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105835:	c9                   	leave  
80105836:	c3                   	ret    
80105837:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583c:	eb f4                	jmp    80105832 <sys_sleep+0xa2>
8010583e:	66 90                	xchg   %ax,%ax

80105840 <sys_uptime>:
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	53                   	push   %ebx
80105844:	83 ec 10             	sub    $0x10,%esp
80105847:	68 60 50 11 80       	push   $0x80115060
8010584c:	e8 df ec ff ff       	call   80104530 <acquire>
80105851:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
80105857:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
8010585e:	e8 8d ed ff ff       	call   801045f0 <release>
80105863:	89 d8                	mov    %ebx,%eax
80105865:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105868:	c9                   	leave  
80105869:	c3                   	ret    

8010586a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010586a:	1e                   	push   %ds
  pushl %es
8010586b:	06                   	push   %es
  pushl %fs
8010586c:	0f a0                	push   %fs
  pushl %gs
8010586e:	0f a8                	push   %gs
  pushal
80105870:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105871:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105875:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105877:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105879:	54                   	push   %esp
  call trap
8010587a:	e8 c1 00 00 00       	call   80105940 <trap>
  addl $4, %esp
8010587f:	83 c4 04             	add    $0x4,%esp

80105882 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105882:	61                   	popa   
  popl %gs
80105883:	0f a9                	pop    %gs
  popl %fs
80105885:	0f a1                	pop    %fs
  popl %es
80105887:	07                   	pop    %es
  popl %ds
80105888:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105889:	83 c4 08             	add    $0x8,%esp
  iret
8010588c:	cf                   	iret   
8010588d:	66 90                	xchg   %ax,%ax
8010588f:	90                   	nop

80105890 <tvinit>:
80105890:	55                   	push   %ebp
80105891:	31 c0                	xor    %eax,%eax
80105893:	89 e5                	mov    %esp,%ebp
80105895:	83 ec 08             	sub    $0x8,%esp
80105898:	90                   	nop
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058a0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801058a7:	c7 04 c5 a2 50 11 80 	movl   $0x8e000008,-0x7feeaf5e(,%eax,8)
801058ae:	08 00 00 8e 
801058b2:	66 89 14 c5 a0 50 11 	mov    %dx,-0x7feeaf60(,%eax,8)
801058b9:	80 
801058ba:	c1 ea 10             	shr    $0x10,%edx
801058bd:	66 89 14 c5 a6 50 11 	mov    %dx,-0x7feeaf5a(,%eax,8)
801058c4:	80 
801058c5:	83 c0 01             	add    $0x1,%eax
801058c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801058cd:	75 d1                	jne    801058a0 <tvinit+0x10>
801058cf:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801058d4:	83 ec 08             	sub    $0x8,%esp
801058d7:	c7 05 a2 52 11 80 08 	movl   $0xef000008,0x801152a2
801058de:	00 00 ef 
801058e1:	68 bd 78 10 80       	push   $0x801078bd
801058e6:	68 60 50 11 80       	push   $0x80115060
801058eb:	66 a3 a0 52 11 80    	mov    %ax,0x801152a0
801058f1:	c1 e8 10             	shr    $0x10,%eax
801058f4:	66 a3 a6 52 11 80    	mov    %ax,0x801152a6
801058fa:	e8 f1 ea ff ff       	call   801043f0 <initlock>
801058ff:	83 c4 10             	add    $0x10,%esp
80105902:	c9                   	leave  
80105903:	c3                   	ret    
80105904:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010590a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105910 <idtinit>:
80105910:	55                   	push   %ebp
80105911:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105916:	89 e5                	mov    %esp,%ebp
80105918:	83 ec 10             	sub    $0x10,%esp
8010591b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
8010591f:	b8 a0 50 11 80       	mov    $0x801150a0,%eax
80105924:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80105928:	c1 e8 10             	shr    $0x10,%eax
8010592b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
8010592f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105932:	0f 01 18             	lidtl  (%eax)
80105935:	c9                   	leave  
80105936:	c3                   	ret    
80105937:	89 f6                	mov    %esi,%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105940 <trap>:
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	57                   	push   %edi
80105944:	56                   	push   %esi
80105945:	53                   	push   %ebx
80105946:	83 ec 1c             	sub    $0x1c,%esp
80105949:	8b 7d 08             	mov    0x8(%ebp),%edi
8010594c:	8b 47 30             	mov    0x30(%edi),%eax
8010594f:	83 f8 40             	cmp    $0x40,%eax
80105952:	0f 84 f0 00 00 00    	je     80105a48 <trap+0x108>
80105958:	83 e8 20             	sub    $0x20,%eax
8010595b:	83 f8 1f             	cmp    $0x1f,%eax
8010595e:	77 10                	ja     80105970 <trap+0x30>
80105960:	ff 24 85 64 79 10 80 	jmp    *-0x7fef869c(,%eax,4)
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105970:	e8 db de ff ff       	call   80103850 <myproc>
80105975:	85 c0                	test   %eax,%eax
80105977:	8b 5f 38             	mov    0x38(%edi),%ebx
8010597a:	0f 84 41 02 00 00    	je     80105bc1 <trap+0x281>
80105980:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105984:	0f 84 37 02 00 00    	je     80105bc1 <trap+0x281>
8010598a:	0f 20 d1             	mov    %cr2,%ecx
8010598d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105990:	e8 9b de ff ff       	call   80103830 <cpuid>
80105995:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105998:	8b 47 34             	mov    0x34(%edi),%eax
8010599b:	8b 77 30             	mov    0x30(%edi),%esi
8010599e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801059a1:	e8 aa de ff ff       	call   80103850 <myproc>
801059a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801059a9:	e8 a2 de ff ff       	call   80103850 <myproc>
801059ae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801059b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801059b4:	51                   	push   %ecx
801059b5:	53                   	push   %ebx
801059b6:	52                   	push   %edx
801059b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801059ba:	ff 75 e4             	pushl  -0x1c(%ebp)
801059bd:	56                   	push   %esi
801059be:	83 c2 6c             	add    $0x6c,%edx
801059c1:	52                   	push   %edx
801059c2:	ff 70 10             	pushl  0x10(%eax)
801059c5:	68 20 79 10 80       	push   $0x80107920
801059ca:	e8 91 ac ff ff       	call   80100660 <cprintf>
801059cf:	83 c4 20             	add    $0x20,%esp
801059d2:	e8 79 de ff ff       	call   80103850 <myproc>
801059d7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801059de:	e8 6d de ff ff       	call   80103850 <myproc>
801059e3:	85 c0                	test   %eax,%eax
801059e5:	74 1d                	je     80105a04 <trap+0xc4>
801059e7:	e8 64 de ff ff       	call   80103850 <myproc>
801059ec:	8b 50 24             	mov    0x24(%eax),%edx
801059ef:	85 d2                	test   %edx,%edx
801059f1:	74 11                	je     80105a04 <trap+0xc4>
801059f3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801059f7:	83 e0 03             	and    $0x3,%eax
801059fa:	66 83 f8 03          	cmp    $0x3,%ax
801059fe:	0f 84 4c 01 00 00    	je     80105b50 <trap+0x210>
80105a04:	e8 47 de ff ff       	call   80103850 <myproc>
80105a09:	85 c0                	test   %eax,%eax
80105a0b:	74 0b                	je     80105a18 <trap+0xd8>
80105a0d:	e8 3e de ff ff       	call   80103850 <myproc>
80105a12:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a16:	74 68                	je     80105a80 <trap+0x140>
80105a18:	e8 33 de ff ff       	call   80103850 <myproc>
80105a1d:	85 c0                	test   %eax,%eax
80105a1f:	74 19                	je     80105a3a <trap+0xfa>
80105a21:	e8 2a de ff ff       	call   80103850 <myproc>
80105a26:	8b 40 24             	mov    0x24(%eax),%eax
80105a29:	85 c0                	test   %eax,%eax
80105a2b:	74 0d                	je     80105a3a <trap+0xfa>
80105a2d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105a31:	83 e0 03             	and    $0x3,%eax
80105a34:	66 83 f8 03          	cmp    $0x3,%ax
80105a38:	74 37                	je     80105a71 <trap+0x131>
80105a3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a3d:	5b                   	pop    %ebx
80105a3e:	5e                   	pop    %esi
80105a3f:	5f                   	pop    %edi
80105a40:	5d                   	pop    %ebp
80105a41:	c3                   	ret    
80105a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a48:	e8 03 de ff ff       	call   80103850 <myproc>
80105a4d:	8b 58 24             	mov    0x24(%eax),%ebx
80105a50:	85 db                	test   %ebx,%ebx
80105a52:	0f 85 e8 00 00 00    	jne    80105b40 <trap+0x200>
80105a58:	e8 f3 dd ff ff       	call   80103850 <myproc>
80105a5d:	89 78 18             	mov    %edi,0x18(%eax)
80105a60:	e8 cb ef ff ff       	call   80104a30 <syscall>
80105a65:	e8 e6 dd ff ff       	call   80103850 <myproc>
80105a6a:	8b 48 24             	mov    0x24(%eax),%ecx
80105a6d:	85 c9                	test   %ecx,%ecx
80105a6f:	74 c9                	je     80105a3a <trap+0xfa>
80105a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a74:	5b                   	pop    %ebx
80105a75:	5e                   	pop    %esi
80105a76:	5f                   	pop    %edi
80105a77:	5d                   	pop    %ebp
80105a78:	e9 23 e2 ff ff       	jmp    80103ca0 <exit>
80105a7d:	8d 76 00             	lea    0x0(%esi),%esi
80105a80:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105a84:	75 92                	jne    80105a18 <trap+0xd8>
80105a86:	e8 55 e3 ff ff       	call   80103de0 <yield>
80105a8b:	eb 8b                	jmp    80105a18 <trap+0xd8>
80105a8d:	8d 76 00             	lea    0x0(%esi),%esi
80105a90:	e8 9b dd ff ff       	call   80103830 <cpuid>
80105a95:	85 c0                	test   %eax,%eax
80105a97:	0f 84 c3 00 00 00    	je     80105b60 <trap+0x220>
80105a9d:	e8 ae cc ff ff       	call   80102750 <lapiceoi>
80105aa2:	e8 a9 dd ff ff       	call   80103850 <myproc>
80105aa7:	85 c0                	test   %eax,%eax
80105aa9:	0f 85 38 ff ff ff    	jne    801059e7 <trap+0xa7>
80105aaf:	e9 50 ff ff ff       	jmp    80105a04 <trap+0xc4>
80105ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ab8:	e8 53 cb ff ff       	call   80102610 <kbdintr>
80105abd:	e8 8e cc ff ff       	call   80102750 <lapiceoi>
80105ac2:	e8 89 dd ff ff       	call   80103850 <myproc>
80105ac7:	85 c0                	test   %eax,%eax
80105ac9:	0f 85 18 ff ff ff    	jne    801059e7 <trap+0xa7>
80105acf:	e9 30 ff ff ff       	jmp    80105a04 <trap+0xc4>
80105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ad8:	e8 83 02 00 00       	call   80105d60 <uartintr>
80105add:	e8 6e cc ff ff       	call   80102750 <lapiceoi>
80105ae2:	e8 69 dd ff ff       	call   80103850 <myproc>
80105ae7:	85 c0                	test   %eax,%eax
80105ae9:	0f 85 f8 fe ff ff    	jne    801059e7 <trap+0xa7>
80105aef:	e9 10 ff ff ff       	jmp    80105a04 <trap+0xc4>
80105af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105af8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105afc:	8b 77 38             	mov    0x38(%edi),%esi
80105aff:	e8 2c dd ff ff       	call   80103830 <cpuid>
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
80105b06:	50                   	push   %eax
80105b07:	68 c8 78 10 80       	push   $0x801078c8
80105b0c:	e8 4f ab ff ff       	call   80100660 <cprintf>
80105b11:	e8 3a cc ff ff       	call   80102750 <lapiceoi>
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	e8 32 dd ff ff       	call   80103850 <myproc>
80105b1e:	85 c0                	test   %eax,%eax
80105b20:	0f 85 c1 fe ff ff    	jne    801059e7 <trap+0xa7>
80105b26:	e9 d9 fe ff ff       	jmp    80105a04 <trap+0xc4>
80105b2b:	90                   	nop
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b30:	e8 4b c5 ff ff       	call   80102080 <ideintr>
80105b35:	e9 63 ff ff ff       	jmp    80105a9d <trap+0x15d>
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b40:	e8 5b e1 ff ff       	call   80103ca0 <exit>
80105b45:	e9 0e ff ff ff       	jmp    80105a58 <trap+0x118>
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b50:	e8 4b e1 ff ff       	call   80103ca0 <exit>
80105b55:	e9 aa fe ff ff       	jmp    80105a04 <trap+0xc4>
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	68 60 50 11 80       	push   $0x80115060
80105b68:	e8 c3 e9 ff ff       	call   80104530 <acquire>
80105b6d:	83 05 a0 58 11 80 01 	addl   $0x1,0x801158a0
80105b74:	e8 e7 db ff ff       	call   80103760 <runinc>
80105b79:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
80105b80:	e8 6b e4 ff ff       	call   80103ff0 <wakeup>
80105b85:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105b8c:	e8 5f ea ff ff       	call   801045f0 <release>
80105b91:	e8 ba dc ff ff       	call   80103850 <myproc>
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	0f 84 fc fe ff ff    	je     80105a9d <trap+0x15d>
80105ba1:	e8 aa dc ff ff       	call   80103850 <myproc>
80105ba6:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105baa:	0f 85 ed fe ff ff    	jne    80105a9d <trap+0x15d>
80105bb0:	e8 9b dc ff ff       	call   80103850 <myproc>
80105bb5:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
80105bbc:	e9 dc fe ff ff       	jmp    80105a9d <trap+0x15d>
80105bc1:	0f 20 d6             	mov    %cr2,%esi
80105bc4:	e8 67 dc ff ff       	call   80103830 <cpuid>
80105bc9:	83 ec 0c             	sub    $0xc,%esp
80105bcc:	56                   	push   %esi
80105bcd:	53                   	push   %ebx
80105bce:	50                   	push   %eax
80105bcf:	ff 77 30             	pushl  0x30(%edi)
80105bd2:	68 ec 78 10 80       	push   $0x801078ec
80105bd7:	e8 84 aa ff ff       	call   80100660 <cprintf>
80105bdc:	83 c4 14             	add    $0x14,%esp
80105bdf:	68 c2 78 10 80       	push   $0x801078c2
80105be4:	e8 a7 a7 ff ff       	call   80100390 <panic>
80105be9:	66 90                	xchg   %ax,%ax
80105beb:	66 90                	xchg   %ax,%ax
80105bed:	66 90                	xchg   %ax,%ax
80105bef:	90                   	nop

80105bf0 <uartgetc>:
80105bf0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105bf5:	55                   	push   %ebp
80105bf6:	89 e5                	mov    %esp,%ebp
80105bf8:	85 c0                	test   %eax,%eax
80105bfa:	74 1c                	je     80105c18 <uartgetc+0x28>
80105bfc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c01:	ec                   	in     (%dx),%al
80105c02:	a8 01                	test   $0x1,%al
80105c04:	74 12                	je     80105c18 <uartgetc+0x28>
80105c06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c0b:	ec                   	in     (%dx),%al
80105c0c:	0f b6 c0             	movzbl %al,%eax
80105c0f:	5d                   	pop    %ebp
80105c10:	c3                   	ret    
80105c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c1d:	5d                   	pop    %ebp
80105c1e:	c3                   	ret    
80105c1f:	90                   	nop

80105c20 <uartputc.part.0>:
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	57                   	push   %edi
80105c24:	56                   	push   %esi
80105c25:	53                   	push   %ebx
80105c26:	89 c7                	mov    %eax,%edi
80105c28:	bb 80 00 00 00       	mov    $0x80,%ebx
80105c2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c32:	83 ec 0c             	sub    $0xc,%esp
80105c35:	eb 1b                	jmp    80105c52 <uartputc.part.0+0x32>
80105c37:	89 f6                	mov    %esi,%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	6a 0a                	push   $0xa
80105c45:	e8 26 cb ff ff       	call   80102770 <microdelay>
80105c4a:	83 c4 10             	add    $0x10,%esp
80105c4d:	83 eb 01             	sub    $0x1,%ebx
80105c50:	74 07                	je     80105c59 <uartputc.part.0+0x39>
80105c52:	89 f2                	mov    %esi,%edx
80105c54:	ec                   	in     (%dx),%al
80105c55:	a8 20                	test   $0x20,%al
80105c57:	74 e7                	je     80105c40 <uartputc.part.0+0x20>
80105c59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c5e:	89 f8                	mov    %edi,%eax
80105c60:	ee                   	out    %al,(%dx)
80105c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c64:	5b                   	pop    %ebx
80105c65:	5e                   	pop    %esi
80105c66:	5f                   	pop    %edi
80105c67:	5d                   	pop    %ebp
80105c68:	c3                   	ret    
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c70 <uartinit>:
80105c70:	55                   	push   %ebp
80105c71:	31 c9                	xor    %ecx,%ecx
80105c73:	89 c8                	mov    %ecx,%eax
80105c75:	89 e5                	mov    %esp,%ebp
80105c77:	57                   	push   %edi
80105c78:	56                   	push   %esi
80105c79:	53                   	push   %ebx
80105c7a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105c7f:	89 da                	mov    %ebx,%edx
80105c81:	83 ec 0c             	sub    $0xc,%esp
80105c84:	ee                   	out    %al,(%dx)
80105c85:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105c8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c8f:	89 fa                	mov    %edi,%edx
80105c91:	ee                   	out    %al,(%dx)
80105c92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c9c:	ee                   	out    %al,(%dx)
80105c9d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105ca2:	89 c8                	mov    %ecx,%eax
80105ca4:	89 f2                	mov    %esi,%edx
80105ca6:	ee                   	out    %al,(%dx)
80105ca7:	b8 03 00 00 00       	mov    $0x3,%eax
80105cac:	89 fa                	mov    %edi,%edx
80105cae:	ee                   	out    %al,(%dx)
80105caf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105cb4:	89 c8                	mov    %ecx,%eax
80105cb6:	ee                   	out    %al,(%dx)
80105cb7:	b8 01 00 00 00       	mov    $0x1,%eax
80105cbc:	89 f2                	mov    %esi,%edx
80105cbe:	ee                   	out    %al,(%dx)
80105cbf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cc4:	ec                   	in     (%dx),%al
80105cc5:	3c ff                	cmp    $0xff,%al
80105cc7:	74 5a                	je     80105d23 <uartinit+0xb3>
80105cc9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105cd0:	00 00 00 
80105cd3:	89 da                	mov    %ebx,%edx
80105cd5:	ec                   	in     (%dx),%al
80105cd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cdb:	ec                   	in     (%dx),%al
80105cdc:	83 ec 08             	sub    $0x8,%esp
80105cdf:	bb e4 79 10 80       	mov    $0x801079e4,%ebx
80105ce4:	6a 00                	push   $0x0
80105ce6:	6a 04                	push   $0x4
80105ce8:	e8 e3 c5 ff ff       	call   801022d0 <ioapicenable>
80105ced:	83 c4 10             	add    $0x10,%esp
80105cf0:	b8 78 00 00 00       	mov    $0x78,%eax
80105cf5:	eb 13                	jmp    80105d0a <uartinit+0x9a>
80105cf7:	89 f6                	mov    %esi,%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105d00:	83 c3 01             	add    $0x1,%ebx
80105d03:	0f be 03             	movsbl (%ebx),%eax
80105d06:	84 c0                	test   %al,%al
80105d08:	74 19                	je     80105d23 <uartinit+0xb3>
80105d0a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105d10:	85 d2                	test   %edx,%edx
80105d12:	74 ec                	je     80105d00 <uartinit+0x90>
80105d14:	83 c3 01             	add    $0x1,%ebx
80105d17:	e8 04 ff ff ff       	call   80105c20 <uartputc.part.0>
80105d1c:	0f be 03             	movsbl (%ebx),%eax
80105d1f:	84 c0                	test   %al,%al
80105d21:	75 e7                	jne    80105d0a <uartinit+0x9a>
80105d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d26:	5b                   	pop    %ebx
80105d27:	5e                   	pop    %esi
80105d28:	5f                   	pop    %edi
80105d29:	5d                   	pop    %ebp
80105d2a:	c3                   	ret    
80105d2b:	90                   	nop
80105d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d30 <uartputc>:
80105d30:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105d36:	55                   	push   %ebp
80105d37:	89 e5                	mov    %esp,%ebp
80105d39:	85 d2                	test   %edx,%edx
80105d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80105d3e:	74 10                	je     80105d50 <uartputc+0x20>
80105d40:	5d                   	pop    %ebp
80105d41:	e9 da fe ff ff       	jmp    80105c20 <uartputc.part.0>
80105d46:	8d 76 00             	lea    0x0(%esi),%esi
80105d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105d50:	5d                   	pop    %ebp
80105d51:	c3                   	ret    
80105d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d60 <uartintr>:
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 14             	sub    $0x14,%esp
80105d66:	68 f0 5b 10 80       	push   $0x80105bf0
80105d6b:	e8 a0 aa ff ff       	call   80100810 <consoleintr>
80105d70:	83 c4 10             	add    $0x10,%esp
80105d73:	c9                   	leave  
80105d74:	c3                   	ret    

80105d75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $0
80105d77:	6a 00                	push   $0x0
  jmp alltraps
80105d79:	e9 ec fa ff ff       	jmp    8010586a <alltraps>

80105d7e <vector1>:
.globl vector1
vector1:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $1
80105d80:	6a 01                	push   $0x1
  jmp alltraps
80105d82:	e9 e3 fa ff ff       	jmp    8010586a <alltraps>

80105d87 <vector2>:
.globl vector2
vector2:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $2
80105d89:	6a 02                	push   $0x2
  jmp alltraps
80105d8b:	e9 da fa ff ff       	jmp    8010586a <alltraps>

80105d90 <vector3>:
.globl vector3
vector3:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $3
80105d92:	6a 03                	push   $0x3
  jmp alltraps
80105d94:	e9 d1 fa ff ff       	jmp    8010586a <alltraps>

80105d99 <vector4>:
.globl vector4
vector4:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $4
80105d9b:	6a 04                	push   $0x4
  jmp alltraps
80105d9d:	e9 c8 fa ff ff       	jmp    8010586a <alltraps>

80105da2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $5
80105da4:	6a 05                	push   $0x5
  jmp alltraps
80105da6:	e9 bf fa ff ff       	jmp    8010586a <alltraps>

80105dab <vector6>:
.globl vector6
vector6:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $6
80105dad:	6a 06                	push   $0x6
  jmp alltraps
80105daf:	e9 b6 fa ff ff       	jmp    8010586a <alltraps>

80105db4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $7
80105db6:	6a 07                	push   $0x7
  jmp alltraps
80105db8:	e9 ad fa ff ff       	jmp    8010586a <alltraps>

80105dbd <vector8>:
.globl vector8
vector8:
  pushl $8
80105dbd:	6a 08                	push   $0x8
  jmp alltraps
80105dbf:	e9 a6 fa ff ff       	jmp    8010586a <alltraps>

80105dc4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $9
80105dc6:	6a 09                	push   $0x9
  jmp alltraps
80105dc8:	e9 9d fa ff ff       	jmp    8010586a <alltraps>

80105dcd <vector10>:
.globl vector10
vector10:
  pushl $10
80105dcd:	6a 0a                	push   $0xa
  jmp alltraps
80105dcf:	e9 96 fa ff ff       	jmp    8010586a <alltraps>

80105dd4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105dd4:	6a 0b                	push   $0xb
  jmp alltraps
80105dd6:	e9 8f fa ff ff       	jmp    8010586a <alltraps>

80105ddb <vector12>:
.globl vector12
vector12:
  pushl $12
80105ddb:	6a 0c                	push   $0xc
  jmp alltraps
80105ddd:	e9 88 fa ff ff       	jmp    8010586a <alltraps>

80105de2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105de2:	6a 0d                	push   $0xd
  jmp alltraps
80105de4:	e9 81 fa ff ff       	jmp    8010586a <alltraps>

80105de9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105de9:	6a 0e                	push   $0xe
  jmp alltraps
80105deb:	e9 7a fa ff ff       	jmp    8010586a <alltraps>

80105df0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105df0:	6a 00                	push   $0x0
  pushl $15
80105df2:	6a 0f                	push   $0xf
  jmp alltraps
80105df4:	e9 71 fa ff ff       	jmp    8010586a <alltraps>

80105df9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105df9:	6a 00                	push   $0x0
  pushl $16
80105dfb:	6a 10                	push   $0x10
  jmp alltraps
80105dfd:	e9 68 fa ff ff       	jmp    8010586a <alltraps>

80105e02 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e02:	6a 11                	push   $0x11
  jmp alltraps
80105e04:	e9 61 fa ff ff       	jmp    8010586a <alltraps>

80105e09 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $18
80105e0b:	6a 12                	push   $0x12
  jmp alltraps
80105e0d:	e9 58 fa ff ff       	jmp    8010586a <alltraps>

80105e12 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $19
80105e14:	6a 13                	push   $0x13
  jmp alltraps
80105e16:	e9 4f fa ff ff       	jmp    8010586a <alltraps>

80105e1b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $20
80105e1d:	6a 14                	push   $0x14
  jmp alltraps
80105e1f:	e9 46 fa ff ff       	jmp    8010586a <alltraps>

80105e24 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e24:	6a 00                	push   $0x0
  pushl $21
80105e26:	6a 15                	push   $0x15
  jmp alltraps
80105e28:	e9 3d fa ff ff       	jmp    8010586a <alltraps>

80105e2d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e2d:	6a 00                	push   $0x0
  pushl $22
80105e2f:	6a 16                	push   $0x16
  jmp alltraps
80105e31:	e9 34 fa ff ff       	jmp    8010586a <alltraps>

80105e36 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $23
80105e38:	6a 17                	push   $0x17
  jmp alltraps
80105e3a:	e9 2b fa ff ff       	jmp    8010586a <alltraps>

80105e3f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $24
80105e41:	6a 18                	push   $0x18
  jmp alltraps
80105e43:	e9 22 fa ff ff       	jmp    8010586a <alltraps>

80105e48 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e48:	6a 00                	push   $0x0
  pushl $25
80105e4a:	6a 19                	push   $0x19
  jmp alltraps
80105e4c:	e9 19 fa ff ff       	jmp    8010586a <alltraps>

80105e51 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e51:	6a 00                	push   $0x0
  pushl $26
80105e53:	6a 1a                	push   $0x1a
  jmp alltraps
80105e55:	e9 10 fa ff ff       	jmp    8010586a <alltraps>

80105e5a <vector27>:
.globl vector27
vector27:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $27
80105e5c:	6a 1b                	push   $0x1b
  jmp alltraps
80105e5e:	e9 07 fa ff ff       	jmp    8010586a <alltraps>

80105e63 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $28
80105e65:	6a 1c                	push   $0x1c
  jmp alltraps
80105e67:	e9 fe f9 ff ff       	jmp    8010586a <alltraps>

80105e6c <vector29>:
.globl vector29
vector29:
  pushl $0
80105e6c:	6a 00                	push   $0x0
  pushl $29
80105e6e:	6a 1d                	push   $0x1d
  jmp alltraps
80105e70:	e9 f5 f9 ff ff       	jmp    8010586a <alltraps>

80105e75 <vector30>:
.globl vector30
vector30:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $30
80105e77:	6a 1e                	push   $0x1e
  jmp alltraps
80105e79:	e9 ec f9 ff ff       	jmp    8010586a <alltraps>

80105e7e <vector31>:
.globl vector31
vector31:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $31
80105e80:	6a 1f                	push   $0x1f
  jmp alltraps
80105e82:	e9 e3 f9 ff ff       	jmp    8010586a <alltraps>

80105e87 <vector32>:
.globl vector32
vector32:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $32
80105e89:	6a 20                	push   $0x20
  jmp alltraps
80105e8b:	e9 da f9 ff ff       	jmp    8010586a <alltraps>

80105e90 <vector33>:
.globl vector33
vector33:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $33
80105e92:	6a 21                	push   $0x21
  jmp alltraps
80105e94:	e9 d1 f9 ff ff       	jmp    8010586a <alltraps>

80105e99 <vector34>:
.globl vector34
vector34:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $34
80105e9b:	6a 22                	push   $0x22
  jmp alltraps
80105e9d:	e9 c8 f9 ff ff       	jmp    8010586a <alltraps>

80105ea2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $35
80105ea4:	6a 23                	push   $0x23
  jmp alltraps
80105ea6:	e9 bf f9 ff ff       	jmp    8010586a <alltraps>

80105eab <vector36>:
.globl vector36
vector36:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $36
80105ead:	6a 24                	push   $0x24
  jmp alltraps
80105eaf:	e9 b6 f9 ff ff       	jmp    8010586a <alltraps>

80105eb4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $37
80105eb6:	6a 25                	push   $0x25
  jmp alltraps
80105eb8:	e9 ad f9 ff ff       	jmp    8010586a <alltraps>

80105ebd <vector38>:
.globl vector38
vector38:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $38
80105ebf:	6a 26                	push   $0x26
  jmp alltraps
80105ec1:	e9 a4 f9 ff ff       	jmp    8010586a <alltraps>

80105ec6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $39
80105ec8:	6a 27                	push   $0x27
  jmp alltraps
80105eca:	e9 9b f9 ff ff       	jmp    8010586a <alltraps>

80105ecf <vector40>:
.globl vector40
vector40:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $40
80105ed1:	6a 28                	push   $0x28
  jmp alltraps
80105ed3:	e9 92 f9 ff ff       	jmp    8010586a <alltraps>

80105ed8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $41
80105eda:	6a 29                	push   $0x29
  jmp alltraps
80105edc:	e9 89 f9 ff ff       	jmp    8010586a <alltraps>

80105ee1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ee1:	6a 00                	push   $0x0
  pushl $42
80105ee3:	6a 2a                	push   $0x2a
  jmp alltraps
80105ee5:	e9 80 f9 ff ff       	jmp    8010586a <alltraps>

80105eea <vector43>:
.globl vector43
vector43:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $43
80105eec:	6a 2b                	push   $0x2b
  jmp alltraps
80105eee:	e9 77 f9 ff ff       	jmp    8010586a <alltraps>

80105ef3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $44
80105ef5:	6a 2c                	push   $0x2c
  jmp alltraps
80105ef7:	e9 6e f9 ff ff       	jmp    8010586a <alltraps>

80105efc <vector45>:
.globl vector45
vector45:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $45
80105efe:	6a 2d                	push   $0x2d
  jmp alltraps
80105f00:	e9 65 f9 ff ff       	jmp    8010586a <alltraps>

80105f05 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $46
80105f07:	6a 2e                	push   $0x2e
  jmp alltraps
80105f09:	e9 5c f9 ff ff       	jmp    8010586a <alltraps>

80105f0e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $47
80105f10:	6a 2f                	push   $0x2f
  jmp alltraps
80105f12:	e9 53 f9 ff ff       	jmp    8010586a <alltraps>

80105f17 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $48
80105f19:	6a 30                	push   $0x30
  jmp alltraps
80105f1b:	e9 4a f9 ff ff       	jmp    8010586a <alltraps>

80105f20 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $49
80105f22:	6a 31                	push   $0x31
  jmp alltraps
80105f24:	e9 41 f9 ff ff       	jmp    8010586a <alltraps>

80105f29 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $50
80105f2b:	6a 32                	push   $0x32
  jmp alltraps
80105f2d:	e9 38 f9 ff ff       	jmp    8010586a <alltraps>

80105f32 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $51
80105f34:	6a 33                	push   $0x33
  jmp alltraps
80105f36:	e9 2f f9 ff ff       	jmp    8010586a <alltraps>

80105f3b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $52
80105f3d:	6a 34                	push   $0x34
  jmp alltraps
80105f3f:	e9 26 f9 ff ff       	jmp    8010586a <alltraps>

80105f44 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $53
80105f46:	6a 35                	push   $0x35
  jmp alltraps
80105f48:	e9 1d f9 ff ff       	jmp    8010586a <alltraps>

80105f4d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f4d:	6a 00                	push   $0x0
  pushl $54
80105f4f:	6a 36                	push   $0x36
  jmp alltraps
80105f51:	e9 14 f9 ff ff       	jmp    8010586a <alltraps>

80105f56 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $55
80105f58:	6a 37                	push   $0x37
  jmp alltraps
80105f5a:	e9 0b f9 ff ff       	jmp    8010586a <alltraps>

80105f5f <vector56>:
.globl vector56
vector56:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $56
80105f61:	6a 38                	push   $0x38
  jmp alltraps
80105f63:	e9 02 f9 ff ff       	jmp    8010586a <alltraps>

80105f68 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $57
80105f6a:	6a 39                	push   $0x39
  jmp alltraps
80105f6c:	e9 f9 f8 ff ff       	jmp    8010586a <alltraps>

80105f71 <vector58>:
.globl vector58
vector58:
  pushl $0
80105f71:	6a 00                	push   $0x0
  pushl $58
80105f73:	6a 3a                	push   $0x3a
  jmp alltraps
80105f75:	e9 f0 f8 ff ff       	jmp    8010586a <alltraps>

80105f7a <vector59>:
.globl vector59
vector59:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $59
80105f7c:	6a 3b                	push   $0x3b
  jmp alltraps
80105f7e:	e9 e7 f8 ff ff       	jmp    8010586a <alltraps>

80105f83 <vector60>:
.globl vector60
vector60:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $60
80105f85:	6a 3c                	push   $0x3c
  jmp alltraps
80105f87:	e9 de f8 ff ff       	jmp    8010586a <alltraps>

80105f8c <vector61>:
.globl vector61
vector61:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $61
80105f8e:	6a 3d                	push   $0x3d
  jmp alltraps
80105f90:	e9 d5 f8 ff ff       	jmp    8010586a <alltraps>

80105f95 <vector62>:
.globl vector62
vector62:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $62
80105f97:	6a 3e                	push   $0x3e
  jmp alltraps
80105f99:	e9 cc f8 ff ff       	jmp    8010586a <alltraps>

80105f9e <vector63>:
.globl vector63
vector63:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $63
80105fa0:	6a 3f                	push   $0x3f
  jmp alltraps
80105fa2:	e9 c3 f8 ff ff       	jmp    8010586a <alltraps>

80105fa7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $64
80105fa9:	6a 40                	push   $0x40
  jmp alltraps
80105fab:	e9 ba f8 ff ff       	jmp    8010586a <alltraps>

80105fb0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $65
80105fb2:	6a 41                	push   $0x41
  jmp alltraps
80105fb4:	e9 b1 f8 ff ff       	jmp    8010586a <alltraps>

80105fb9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $66
80105fbb:	6a 42                	push   $0x42
  jmp alltraps
80105fbd:	e9 a8 f8 ff ff       	jmp    8010586a <alltraps>

80105fc2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $67
80105fc4:	6a 43                	push   $0x43
  jmp alltraps
80105fc6:	e9 9f f8 ff ff       	jmp    8010586a <alltraps>

80105fcb <vector68>:
.globl vector68
vector68:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $68
80105fcd:	6a 44                	push   $0x44
  jmp alltraps
80105fcf:	e9 96 f8 ff ff       	jmp    8010586a <alltraps>

80105fd4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $69
80105fd6:	6a 45                	push   $0x45
  jmp alltraps
80105fd8:	e9 8d f8 ff ff       	jmp    8010586a <alltraps>

80105fdd <vector70>:
.globl vector70
vector70:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $70
80105fdf:	6a 46                	push   $0x46
  jmp alltraps
80105fe1:	e9 84 f8 ff ff       	jmp    8010586a <alltraps>

80105fe6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $71
80105fe8:	6a 47                	push   $0x47
  jmp alltraps
80105fea:	e9 7b f8 ff ff       	jmp    8010586a <alltraps>

80105fef <vector72>:
.globl vector72
vector72:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $72
80105ff1:	6a 48                	push   $0x48
  jmp alltraps
80105ff3:	e9 72 f8 ff ff       	jmp    8010586a <alltraps>

80105ff8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $73
80105ffa:	6a 49                	push   $0x49
  jmp alltraps
80105ffc:	e9 69 f8 ff ff       	jmp    8010586a <alltraps>

80106001 <vector74>:
.globl vector74
vector74:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $74
80106003:	6a 4a                	push   $0x4a
  jmp alltraps
80106005:	e9 60 f8 ff ff       	jmp    8010586a <alltraps>

8010600a <vector75>:
.globl vector75
vector75:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $75
8010600c:	6a 4b                	push   $0x4b
  jmp alltraps
8010600e:	e9 57 f8 ff ff       	jmp    8010586a <alltraps>

80106013 <vector76>:
.globl vector76
vector76:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $76
80106015:	6a 4c                	push   $0x4c
  jmp alltraps
80106017:	e9 4e f8 ff ff       	jmp    8010586a <alltraps>

8010601c <vector77>:
.globl vector77
vector77:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $77
8010601e:	6a 4d                	push   $0x4d
  jmp alltraps
80106020:	e9 45 f8 ff ff       	jmp    8010586a <alltraps>

80106025 <vector78>:
.globl vector78
vector78:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $78
80106027:	6a 4e                	push   $0x4e
  jmp alltraps
80106029:	e9 3c f8 ff ff       	jmp    8010586a <alltraps>

8010602e <vector79>:
.globl vector79
vector79:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $79
80106030:	6a 4f                	push   $0x4f
  jmp alltraps
80106032:	e9 33 f8 ff ff       	jmp    8010586a <alltraps>

80106037 <vector80>:
.globl vector80
vector80:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $80
80106039:	6a 50                	push   $0x50
  jmp alltraps
8010603b:	e9 2a f8 ff ff       	jmp    8010586a <alltraps>

80106040 <vector81>:
.globl vector81
vector81:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $81
80106042:	6a 51                	push   $0x51
  jmp alltraps
80106044:	e9 21 f8 ff ff       	jmp    8010586a <alltraps>

80106049 <vector82>:
.globl vector82
vector82:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $82
8010604b:	6a 52                	push   $0x52
  jmp alltraps
8010604d:	e9 18 f8 ff ff       	jmp    8010586a <alltraps>

80106052 <vector83>:
.globl vector83
vector83:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $83
80106054:	6a 53                	push   $0x53
  jmp alltraps
80106056:	e9 0f f8 ff ff       	jmp    8010586a <alltraps>

8010605b <vector84>:
.globl vector84
vector84:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $84
8010605d:	6a 54                	push   $0x54
  jmp alltraps
8010605f:	e9 06 f8 ff ff       	jmp    8010586a <alltraps>

80106064 <vector85>:
.globl vector85
vector85:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $85
80106066:	6a 55                	push   $0x55
  jmp alltraps
80106068:	e9 fd f7 ff ff       	jmp    8010586a <alltraps>

8010606d <vector86>:
.globl vector86
vector86:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $86
8010606f:	6a 56                	push   $0x56
  jmp alltraps
80106071:	e9 f4 f7 ff ff       	jmp    8010586a <alltraps>

80106076 <vector87>:
.globl vector87
vector87:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $87
80106078:	6a 57                	push   $0x57
  jmp alltraps
8010607a:	e9 eb f7 ff ff       	jmp    8010586a <alltraps>

8010607f <vector88>:
.globl vector88
vector88:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $88
80106081:	6a 58                	push   $0x58
  jmp alltraps
80106083:	e9 e2 f7 ff ff       	jmp    8010586a <alltraps>

80106088 <vector89>:
.globl vector89
vector89:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $89
8010608a:	6a 59                	push   $0x59
  jmp alltraps
8010608c:	e9 d9 f7 ff ff       	jmp    8010586a <alltraps>

80106091 <vector90>:
.globl vector90
vector90:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $90
80106093:	6a 5a                	push   $0x5a
  jmp alltraps
80106095:	e9 d0 f7 ff ff       	jmp    8010586a <alltraps>

8010609a <vector91>:
.globl vector91
vector91:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $91
8010609c:	6a 5b                	push   $0x5b
  jmp alltraps
8010609e:	e9 c7 f7 ff ff       	jmp    8010586a <alltraps>

801060a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $92
801060a5:	6a 5c                	push   $0x5c
  jmp alltraps
801060a7:	e9 be f7 ff ff       	jmp    8010586a <alltraps>

801060ac <vector93>:
.globl vector93
vector93:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $93
801060ae:	6a 5d                	push   $0x5d
  jmp alltraps
801060b0:	e9 b5 f7 ff ff       	jmp    8010586a <alltraps>

801060b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $94
801060b7:	6a 5e                	push   $0x5e
  jmp alltraps
801060b9:	e9 ac f7 ff ff       	jmp    8010586a <alltraps>

801060be <vector95>:
.globl vector95
vector95:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $95
801060c0:	6a 5f                	push   $0x5f
  jmp alltraps
801060c2:	e9 a3 f7 ff ff       	jmp    8010586a <alltraps>

801060c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $96
801060c9:	6a 60                	push   $0x60
  jmp alltraps
801060cb:	e9 9a f7 ff ff       	jmp    8010586a <alltraps>

801060d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $97
801060d2:	6a 61                	push   $0x61
  jmp alltraps
801060d4:	e9 91 f7 ff ff       	jmp    8010586a <alltraps>

801060d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $98
801060db:	6a 62                	push   $0x62
  jmp alltraps
801060dd:	e9 88 f7 ff ff       	jmp    8010586a <alltraps>

801060e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $99
801060e4:	6a 63                	push   $0x63
  jmp alltraps
801060e6:	e9 7f f7 ff ff       	jmp    8010586a <alltraps>

801060eb <vector100>:
.globl vector100
vector100:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $100
801060ed:	6a 64                	push   $0x64
  jmp alltraps
801060ef:	e9 76 f7 ff ff       	jmp    8010586a <alltraps>

801060f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $101
801060f6:	6a 65                	push   $0x65
  jmp alltraps
801060f8:	e9 6d f7 ff ff       	jmp    8010586a <alltraps>

801060fd <vector102>:
.globl vector102
vector102:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $102
801060ff:	6a 66                	push   $0x66
  jmp alltraps
80106101:	e9 64 f7 ff ff       	jmp    8010586a <alltraps>

80106106 <vector103>:
.globl vector103
vector103:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $103
80106108:	6a 67                	push   $0x67
  jmp alltraps
8010610a:	e9 5b f7 ff ff       	jmp    8010586a <alltraps>

8010610f <vector104>:
.globl vector104
vector104:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $104
80106111:	6a 68                	push   $0x68
  jmp alltraps
80106113:	e9 52 f7 ff ff       	jmp    8010586a <alltraps>

80106118 <vector105>:
.globl vector105
vector105:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $105
8010611a:	6a 69                	push   $0x69
  jmp alltraps
8010611c:	e9 49 f7 ff ff       	jmp    8010586a <alltraps>

80106121 <vector106>:
.globl vector106
vector106:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $106
80106123:	6a 6a                	push   $0x6a
  jmp alltraps
80106125:	e9 40 f7 ff ff       	jmp    8010586a <alltraps>

8010612a <vector107>:
.globl vector107
vector107:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $107
8010612c:	6a 6b                	push   $0x6b
  jmp alltraps
8010612e:	e9 37 f7 ff ff       	jmp    8010586a <alltraps>

80106133 <vector108>:
.globl vector108
vector108:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $108
80106135:	6a 6c                	push   $0x6c
  jmp alltraps
80106137:	e9 2e f7 ff ff       	jmp    8010586a <alltraps>

8010613c <vector109>:
.globl vector109
vector109:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $109
8010613e:	6a 6d                	push   $0x6d
  jmp alltraps
80106140:	e9 25 f7 ff ff       	jmp    8010586a <alltraps>

80106145 <vector110>:
.globl vector110
vector110:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $110
80106147:	6a 6e                	push   $0x6e
  jmp alltraps
80106149:	e9 1c f7 ff ff       	jmp    8010586a <alltraps>

8010614e <vector111>:
.globl vector111
vector111:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $111
80106150:	6a 6f                	push   $0x6f
  jmp alltraps
80106152:	e9 13 f7 ff ff       	jmp    8010586a <alltraps>

80106157 <vector112>:
.globl vector112
vector112:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $112
80106159:	6a 70                	push   $0x70
  jmp alltraps
8010615b:	e9 0a f7 ff ff       	jmp    8010586a <alltraps>

80106160 <vector113>:
.globl vector113
vector113:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $113
80106162:	6a 71                	push   $0x71
  jmp alltraps
80106164:	e9 01 f7 ff ff       	jmp    8010586a <alltraps>

80106169 <vector114>:
.globl vector114
vector114:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $114
8010616b:	6a 72                	push   $0x72
  jmp alltraps
8010616d:	e9 f8 f6 ff ff       	jmp    8010586a <alltraps>

80106172 <vector115>:
.globl vector115
vector115:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $115
80106174:	6a 73                	push   $0x73
  jmp alltraps
80106176:	e9 ef f6 ff ff       	jmp    8010586a <alltraps>

8010617b <vector116>:
.globl vector116
vector116:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $116
8010617d:	6a 74                	push   $0x74
  jmp alltraps
8010617f:	e9 e6 f6 ff ff       	jmp    8010586a <alltraps>

80106184 <vector117>:
.globl vector117
vector117:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $117
80106186:	6a 75                	push   $0x75
  jmp alltraps
80106188:	e9 dd f6 ff ff       	jmp    8010586a <alltraps>

8010618d <vector118>:
.globl vector118
vector118:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $118
8010618f:	6a 76                	push   $0x76
  jmp alltraps
80106191:	e9 d4 f6 ff ff       	jmp    8010586a <alltraps>

80106196 <vector119>:
.globl vector119
vector119:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $119
80106198:	6a 77                	push   $0x77
  jmp alltraps
8010619a:	e9 cb f6 ff ff       	jmp    8010586a <alltraps>

8010619f <vector120>:
.globl vector120
vector120:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $120
801061a1:	6a 78                	push   $0x78
  jmp alltraps
801061a3:	e9 c2 f6 ff ff       	jmp    8010586a <alltraps>

801061a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $121
801061aa:	6a 79                	push   $0x79
  jmp alltraps
801061ac:	e9 b9 f6 ff ff       	jmp    8010586a <alltraps>

801061b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $122
801061b3:	6a 7a                	push   $0x7a
  jmp alltraps
801061b5:	e9 b0 f6 ff ff       	jmp    8010586a <alltraps>

801061ba <vector123>:
.globl vector123
vector123:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $123
801061bc:	6a 7b                	push   $0x7b
  jmp alltraps
801061be:	e9 a7 f6 ff ff       	jmp    8010586a <alltraps>

801061c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $124
801061c5:	6a 7c                	push   $0x7c
  jmp alltraps
801061c7:	e9 9e f6 ff ff       	jmp    8010586a <alltraps>

801061cc <vector125>:
.globl vector125
vector125:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $125
801061ce:	6a 7d                	push   $0x7d
  jmp alltraps
801061d0:	e9 95 f6 ff ff       	jmp    8010586a <alltraps>

801061d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $126
801061d7:	6a 7e                	push   $0x7e
  jmp alltraps
801061d9:	e9 8c f6 ff ff       	jmp    8010586a <alltraps>

801061de <vector127>:
.globl vector127
vector127:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $127
801061e0:	6a 7f                	push   $0x7f
  jmp alltraps
801061e2:	e9 83 f6 ff ff       	jmp    8010586a <alltraps>

801061e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $128
801061e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801061ee:	e9 77 f6 ff ff       	jmp    8010586a <alltraps>

801061f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $129
801061f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801061fa:	e9 6b f6 ff ff       	jmp    8010586a <alltraps>

801061ff <vector130>:
.globl vector130
vector130:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $130
80106201:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106206:	e9 5f f6 ff ff       	jmp    8010586a <alltraps>

8010620b <vector131>:
.globl vector131
vector131:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $131
8010620d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106212:	e9 53 f6 ff ff       	jmp    8010586a <alltraps>

80106217 <vector132>:
.globl vector132
vector132:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $132
80106219:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010621e:	e9 47 f6 ff ff       	jmp    8010586a <alltraps>

80106223 <vector133>:
.globl vector133
vector133:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $133
80106225:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010622a:	e9 3b f6 ff ff       	jmp    8010586a <alltraps>

8010622f <vector134>:
.globl vector134
vector134:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $134
80106231:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106236:	e9 2f f6 ff ff       	jmp    8010586a <alltraps>

8010623b <vector135>:
.globl vector135
vector135:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $135
8010623d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106242:	e9 23 f6 ff ff       	jmp    8010586a <alltraps>

80106247 <vector136>:
.globl vector136
vector136:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $136
80106249:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010624e:	e9 17 f6 ff ff       	jmp    8010586a <alltraps>

80106253 <vector137>:
.globl vector137
vector137:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $137
80106255:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010625a:	e9 0b f6 ff ff       	jmp    8010586a <alltraps>

8010625f <vector138>:
.globl vector138
vector138:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $138
80106261:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106266:	e9 ff f5 ff ff       	jmp    8010586a <alltraps>

8010626b <vector139>:
.globl vector139
vector139:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $139
8010626d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106272:	e9 f3 f5 ff ff       	jmp    8010586a <alltraps>

80106277 <vector140>:
.globl vector140
vector140:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $140
80106279:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010627e:	e9 e7 f5 ff ff       	jmp    8010586a <alltraps>

80106283 <vector141>:
.globl vector141
vector141:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $141
80106285:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010628a:	e9 db f5 ff ff       	jmp    8010586a <alltraps>

8010628f <vector142>:
.globl vector142
vector142:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $142
80106291:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106296:	e9 cf f5 ff ff       	jmp    8010586a <alltraps>

8010629b <vector143>:
.globl vector143
vector143:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $143
8010629d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062a2:	e9 c3 f5 ff ff       	jmp    8010586a <alltraps>

801062a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $144
801062a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062ae:	e9 b7 f5 ff ff       	jmp    8010586a <alltraps>

801062b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $145
801062b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062ba:	e9 ab f5 ff ff       	jmp    8010586a <alltraps>

801062bf <vector146>:
.globl vector146
vector146:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $146
801062c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801062c6:	e9 9f f5 ff ff       	jmp    8010586a <alltraps>

801062cb <vector147>:
.globl vector147
vector147:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $147
801062cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801062d2:	e9 93 f5 ff ff       	jmp    8010586a <alltraps>

801062d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $148
801062d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801062de:	e9 87 f5 ff ff       	jmp    8010586a <alltraps>

801062e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $149
801062e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801062ea:	e9 7b f5 ff ff       	jmp    8010586a <alltraps>

801062ef <vector150>:
.globl vector150
vector150:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $150
801062f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801062f6:	e9 6f f5 ff ff       	jmp    8010586a <alltraps>

801062fb <vector151>:
.globl vector151
vector151:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $151
801062fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106302:	e9 63 f5 ff ff       	jmp    8010586a <alltraps>

80106307 <vector152>:
.globl vector152
vector152:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $152
80106309:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010630e:	e9 57 f5 ff ff       	jmp    8010586a <alltraps>

80106313 <vector153>:
.globl vector153
vector153:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $153
80106315:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010631a:	e9 4b f5 ff ff       	jmp    8010586a <alltraps>

8010631f <vector154>:
.globl vector154
vector154:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $154
80106321:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106326:	e9 3f f5 ff ff       	jmp    8010586a <alltraps>

8010632b <vector155>:
.globl vector155
vector155:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $155
8010632d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106332:	e9 33 f5 ff ff       	jmp    8010586a <alltraps>

80106337 <vector156>:
.globl vector156
vector156:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $156
80106339:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010633e:	e9 27 f5 ff ff       	jmp    8010586a <alltraps>

80106343 <vector157>:
.globl vector157
vector157:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $157
80106345:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010634a:	e9 1b f5 ff ff       	jmp    8010586a <alltraps>

8010634f <vector158>:
.globl vector158
vector158:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $158
80106351:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106356:	e9 0f f5 ff ff       	jmp    8010586a <alltraps>

8010635b <vector159>:
.globl vector159
vector159:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $159
8010635d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106362:	e9 03 f5 ff ff       	jmp    8010586a <alltraps>

80106367 <vector160>:
.globl vector160
vector160:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $160
80106369:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010636e:	e9 f7 f4 ff ff       	jmp    8010586a <alltraps>

80106373 <vector161>:
.globl vector161
vector161:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $161
80106375:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010637a:	e9 eb f4 ff ff       	jmp    8010586a <alltraps>

8010637f <vector162>:
.globl vector162
vector162:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $162
80106381:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106386:	e9 df f4 ff ff       	jmp    8010586a <alltraps>

8010638b <vector163>:
.globl vector163
vector163:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $163
8010638d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106392:	e9 d3 f4 ff ff       	jmp    8010586a <alltraps>

80106397 <vector164>:
.globl vector164
vector164:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $164
80106399:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010639e:	e9 c7 f4 ff ff       	jmp    8010586a <alltraps>

801063a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $165
801063a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063aa:	e9 bb f4 ff ff       	jmp    8010586a <alltraps>

801063af <vector166>:
.globl vector166
vector166:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $166
801063b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063b6:	e9 af f4 ff ff       	jmp    8010586a <alltraps>

801063bb <vector167>:
.globl vector167
vector167:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $167
801063bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801063c2:	e9 a3 f4 ff ff       	jmp    8010586a <alltraps>

801063c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $168
801063c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801063ce:	e9 97 f4 ff ff       	jmp    8010586a <alltraps>

801063d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $169
801063d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801063da:	e9 8b f4 ff ff       	jmp    8010586a <alltraps>

801063df <vector170>:
.globl vector170
vector170:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $170
801063e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801063e6:	e9 7f f4 ff ff       	jmp    8010586a <alltraps>

801063eb <vector171>:
.globl vector171
vector171:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $171
801063ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801063f2:	e9 73 f4 ff ff       	jmp    8010586a <alltraps>

801063f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $172
801063f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801063fe:	e9 67 f4 ff ff       	jmp    8010586a <alltraps>

80106403 <vector173>:
.globl vector173
vector173:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $173
80106405:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010640a:	e9 5b f4 ff ff       	jmp    8010586a <alltraps>

8010640f <vector174>:
.globl vector174
vector174:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $174
80106411:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106416:	e9 4f f4 ff ff       	jmp    8010586a <alltraps>

8010641b <vector175>:
.globl vector175
vector175:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $175
8010641d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106422:	e9 43 f4 ff ff       	jmp    8010586a <alltraps>

80106427 <vector176>:
.globl vector176
vector176:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $176
80106429:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010642e:	e9 37 f4 ff ff       	jmp    8010586a <alltraps>

80106433 <vector177>:
.globl vector177
vector177:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $177
80106435:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010643a:	e9 2b f4 ff ff       	jmp    8010586a <alltraps>

8010643f <vector178>:
.globl vector178
vector178:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $178
80106441:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106446:	e9 1f f4 ff ff       	jmp    8010586a <alltraps>

8010644b <vector179>:
.globl vector179
vector179:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $179
8010644d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106452:	e9 13 f4 ff ff       	jmp    8010586a <alltraps>

80106457 <vector180>:
.globl vector180
vector180:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $180
80106459:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010645e:	e9 07 f4 ff ff       	jmp    8010586a <alltraps>

80106463 <vector181>:
.globl vector181
vector181:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $181
80106465:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010646a:	e9 fb f3 ff ff       	jmp    8010586a <alltraps>

8010646f <vector182>:
.globl vector182
vector182:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $182
80106471:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106476:	e9 ef f3 ff ff       	jmp    8010586a <alltraps>

8010647b <vector183>:
.globl vector183
vector183:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $183
8010647d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106482:	e9 e3 f3 ff ff       	jmp    8010586a <alltraps>

80106487 <vector184>:
.globl vector184
vector184:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $184
80106489:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010648e:	e9 d7 f3 ff ff       	jmp    8010586a <alltraps>

80106493 <vector185>:
.globl vector185
vector185:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $185
80106495:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010649a:	e9 cb f3 ff ff       	jmp    8010586a <alltraps>

8010649f <vector186>:
.globl vector186
vector186:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $186
801064a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064a6:	e9 bf f3 ff ff       	jmp    8010586a <alltraps>

801064ab <vector187>:
.globl vector187
vector187:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $187
801064ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064b2:	e9 b3 f3 ff ff       	jmp    8010586a <alltraps>

801064b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $188
801064b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064be:	e9 a7 f3 ff ff       	jmp    8010586a <alltraps>

801064c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $189
801064c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801064ca:	e9 9b f3 ff ff       	jmp    8010586a <alltraps>

801064cf <vector190>:
.globl vector190
vector190:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $190
801064d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801064d6:	e9 8f f3 ff ff       	jmp    8010586a <alltraps>

801064db <vector191>:
.globl vector191
vector191:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $191
801064dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801064e2:	e9 83 f3 ff ff       	jmp    8010586a <alltraps>

801064e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $192
801064e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801064ee:	e9 77 f3 ff ff       	jmp    8010586a <alltraps>

801064f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $193
801064f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801064fa:	e9 6b f3 ff ff       	jmp    8010586a <alltraps>

801064ff <vector194>:
.globl vector194
vector194:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $194
80106501:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106506:	e9 5f f3 ff ff       	jmp    8010586a <alltraps>

8010650b <vector195>:
.globl vector195
vector195:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $195
8010650d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106512:	e9 53 f3 ff ff       	jmp    8010586a <alltraps>

80106517 <vector196>:
.globl vector196
vector196:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $196
80106519:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010651e:	e9 47 f3 ff ff       	jmp    8010586a <alltraps>

80106523 <vector197>:
.globl vector197
vector197:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $197
80106525:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010652a:	e9 3b f3 ff ff       	jmp    8010586a <alltraps>

8010652f <vector198>:
.globl vector198
vector198:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $198
80106531:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106536:	e9 2f f3 ff ff       	jmp    8010586a <alltraps>

8010653b <vector199>:
.globl vector199
vector199:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $199
8010653d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106542:	e9 23 f3 ff ff       	jmp    8010586a <alltraps>

80106547 <vector200>:
.globl vector200
vector200:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $200
80106549:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010654e:	e9 17 f3 ff ff       	jmp    8010586a <alltraps>

80106553 <vector201>:
.globl vector201
vector201:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $201
80106555:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010655a:	e9 0b f3 ff ff       	jmp    8010586a <alltraps>

8010655f <vector202>:
.globl vector202
vector202:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $202
80106561:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106566:	e9 ff f2 ff ff       	jmp    8010586a <alltraps>

8010656b <vector203>:
.globl vector203
vector203:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $203
8010656d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106572:	e9 f3 f2 ff ff       	jmp    8010586a <alltraps>

80106577 <vector204>:
.globl vector204
vector204:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $204
80106579:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010657e:	e9 e7 f2 ff ff       	jmp    8010586a <alltraps>

80106583 <vector205>:
.globl vector205
vector205:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $205
80106585:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010658a:	e9 db f2 ff ff       	jmp    8010586a <alltraps>

8010658f <vector206>:
.globl vector206
vector206:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $206
80106591:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106596:	e9 cf f2 ff ff       	jmp    8010586a <alltraps>

8010659b <vector207>:
.globl vector207
vector207:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $207
8010659d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065a2:	e9 c3 f2 ff ff       	jmp    8010586a <alltraps>

801065a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $208
801065a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065ae:	e9 b7 f2 ff ff       	jmp    8010586a <alltraps>

801065b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $209
801065b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065ba:	e9 ab f2 ff ff       	jmp    8010586a <alltraps>

801065bf <vector210>:
.globl vector210
vector210:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $210
801065c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801065c6:	e9 9f f2 ff ff       	jmp    8010586a <alltraps>

801065cb <vector211>:
.globl vector211
vector211:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $211
801065cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801065d2:	e9 93 f2 ff ff       	jmp    8010586a <alltraps>

801065d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $212
801065d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801065de:	e9 87 f2 ff ff       	jmp    8010586a <alltraps>

801065e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $213
801065e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801065ea:	e9 7b f2 ff ff       	jmp    8010586a <alltraps>

801065ef <vector214>:
.globl vector214
vector214:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $214
801065f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801065f6:	e9 6f f2 ff ff       	jmp    8010586a <alltraps>

801065fb <vector215>:
.globl vector215
vector215:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $215
801065fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106602:	e9 63 f2 ff ff       	jmp    8010586a <alltraps>

80106607 <vector216>:
.globl vector216
vector216:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $216
80106609:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010660e:	e9 57 f2 ff ff       	jmp    8010586a <alltraps>

80106613 <vector217>:
.globl vector217
vector217:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $217
80106615:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010661a:	e9 4b f2 ff ff       	jmp    8010586a <alltraps>

8010661f <vector218>:
.globl vector218
vector218:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $218
80106621:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106626:	e9 3f f2 ff ff       	jmp    8010586a <alltraps>

8010662b <vector219>:
.globl vector219
vector219:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $219
8010662d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106632:	e9 33 f2 ff ff       	jmp    8010586a <alltraps>

80106637 <vector220>:
.globl vector220
vector220:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $220
80106639:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010663e:	e9 27 f2 ff ff       	jmp    8010586a <alltraps>

80106643 <vector221>:
.globl vector221
vector221:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $221
80106645:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010664a:	e9 1b f2 ff ff       	jmp    8010586a <alltraps>

8010664f <vector222>:
.globl vector222
vector222:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $222
80106651:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106656:	e9 0f f2 ff ff       	jmp    8010586a <alltraps>

8010665b <vector223>:
.globl vector223
vector223:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $223
8010665d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106662:	e9 03 f2 ff ff       	jmp    8010586a <alltraps>

80106667 <vector224>:
.globl vector224
vector224:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $224
80106669:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010666e:	e9 f7 f1 ff ff       	jmp    8010586a <alltraps>

80106673 <vector225>:
.globl vector225
vector225:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $225
80106675:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010667a:	e9 eb f1 ff ff       	jmp    8010586a <alltraps>

8010667f <vector226>:
.globl vector226
vector226:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $226
80106681:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106686:	e9 df f1 ff ff       	jmp    8010586a <alltraps>

8010668b <vector227>:
.globl vector227
vector227:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $227
8010668d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106692:	e9 d3 f1 ff ff       	jmp    8010586a <alltraps>

80106697 <vector228>:
.globl vector228
vector228:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $228
80106699:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010669e:	e9 c7 f1 ff ff       	jmp    8010586a <alltraps>

801066a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $229
801066a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066aa:	e9 bb f1 ff ff       	jmp    8010586a <alltraps>

801066af <vector230>:
.globl vector230
vector230:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $230
801066b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066b6:	e9 af f1 ff ff       	jmp    8010586a <alltraps>

801066bb <vector231>:
.globl vector231
vector231:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $231
801066bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801066c2:	e9 a3 f1 ff ff       	jmp    8010586a <alltraps>

801066c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $232
801066c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801066ce:	e9 97 f1 ff ff       	jmp    8010586a <alltraps>

801066d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $233
801066d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801066da:	e9 8b f1 ff ff       	jmp    8010586a <alltraps>

801066df <vector234>:
.globl vector234
vector234:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $234
801066e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801066e6:	e9 7f f1 ff ff       	jmp    8010586a <alltraps>

801066eb <vector235>:
.globl vector235
vector235:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $235
801066ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801066f2:	e9 73 f1 ff ff       	jmp    8010586a <alltraps>

801066f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $236
801066f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801066fe:	e9 67 f1 ff ff       	jmp    8010586a <alltraps>

80106703 <vector237>:
.globl vector237
vector237:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $237
80106705:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010670a:	e9 5b f1 ff ff       	jmp    8010586a <alltraps>

8010670f <vector238>:
.globl vector238
vector238:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $238
80106711:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106716:	e9 4f f1 ff ff       	jmp    8010586a <alltraps>

8010671b <vector239>:
.globl vector239
vector239:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $239
8010671d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106722:	e9 43 f1 ff ff       	jmp    8010586a <alltraps>

80106727 <vector240>:
.globl vector240
vector240:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $240
80106729:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010672e:	e9 37 f1 ff ff       	jmp    8010586a <alltraps>

80106733 <vector241>:
.globl vector241
vector241:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $241
80106735:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010673a:	e9 2b f1 ff ff       	jmp    8010586a <alltraps>

8010673f <vector242>:
.globl vector242
vector242:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $242
80106741:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106746:	e9 1f f1 ff ff       	jmp    8010586a <alltraps>

8010674b <vector243>:
.globl vector243
vector243:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $243
8010674d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106752:	e9 13 f1 ff ff       	jmp    8010586a <alltraps>

80106757 <vector244>:
.globl vector244
vector244:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $244
80106759:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010675e:	e9 07 f1 ff ff       	jmp    8010586a <alltraps>

80106763 <vector245>:
.globl vector245
vector245:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $245
80106765:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010676a:	e9 fb f0 ff ff       	jmp    8010586a <alltraps>

8010676f <vector246>:
.globl vector246
vector246:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $246
80106771:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106776:	e9 ef f0 ff ff       	jmp    8010586a <alltraps>

8010677b <vector247>:
.globl vector247
vector247:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $247
8010677d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106782:	e9 e3 f0 ff ff       	jmp    8010586a <alltraps>

80106787 <vector248>:
.globl vector248
vector248:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $248
80106789:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010678e:	e9 d7 f0 ff ff       	jmp    8010586a <alltraps>

80106793 <vector249>:
.globl vector249
vector249:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $249
80106795:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010679a:	e9 cb f0 ff ff       	jmp    8010586a <alltraps>

8010679f <vector250>:
.globl vector250
vector250:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $250
801067a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067a6:	e9 bf f0 ff ff       	jmp    8010586a <alltraps>

801067ab <vector251>:
.globl vector251
vector251:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $251
801067ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067b2:	e9 b3 f0 ff ff       	jmp    8010586a <alltraps>

801067b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $252
801067b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067be:	e9 a7 f0 ff ff       	jmp    8010586a <alltraps>

801067c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $253
801067c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801067ca:	e9 9b f0 ff ff       	jmp    8010586a <alltraps>

801067cf <vector254>:
.globl vector254
vector254:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $254
801067d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801067d6:	e9 8f f0 ff ff       	jmp    8010586a <alltraps>

801067db <vector255>:
.globl vector255
vector255:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $255
801067dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801067e2:	e9 83 f0 ff ff       	jmp    8010586a <alltraps>
801067e7:	66 90                	xchg   %ax,%ax
801067e9:	66 90                	xchg   %ax,%ax
801067eb:	66 90                	xchg   %ax,%ax
801067ed:	66 90                	xchg   %ax,%ax
801067ef:	90                   	nop

801067f0 <walkpgdir>:
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	57                   	push   %edi
801067f4:	56                   	push   %esi
801067f5:	53                   	push   %ebx
801067f6:	89 d3                	mov    %edx,%ebx
801067f8:	89 d7                	mov    %edx,%edi
801067fa:	c1 eb 16             	shr    $0x16,%ebx
801067fd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
80106800:	83 ec 0c             	sub    $0xc,%esp
80106803:	8b 06                	mov    (%esi),%eax
80106805:	a8 01                	test   $0x1,%al
80106807:	74 27                	je     80106830 <walkpgdir+0x40>
80106809:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010680e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80106814:	c1 ef 0a             	shr    $0xa,%edi
80106817:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010681a:	89 fa                	mov    %edi,%edx
8010681c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106822:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80106825:	5b                   	pop    %ebx
80106826:	5e                   	pop    %esi
80106827:	5f                   	pop    %edi
80106828:	5d                   	pop    %ebp
80106829:	c3                   	ret    
8010682a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106830:	85 c9                	test   %ecx,%ecx
80106832:	74 2c                	je     80106860 <walkpgdir+0x70>
80106834:	e8 87 bc ff ff       	call   801024c0 <kalloc>
80106839:	85 c0                	test   %eax,%eax
8010683b:	89 c3                	mov    %eax,%ebx
8010683d:	74 21                	je     80106860 <walkpgdir+0x70>
8010683f:	83 ec 04             	sub    $0x4,%esp
80106842:	68 00 10 00 00       	push   $0x1000
80106847:	6a 00                	push   $0x0
80106849:	50                   	push   %eax
8010684a:	e8 f1 dd ff ff       	call   80104640 <memset>
8010684f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106855:	83 c4 10             	add    $0x10,%esp
80106858:	83 c8 07             	or     $0x7,%eax
8010685b:	89 06                	mov    %eax,(%esi)
8010685d:	eb b5                	jmp    80106814 <walkpgdir+0x24>
8010685f:	90                   	nop
80106860:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106863:	31 c0                	xor    %eax,%eax
80106865:	5b                   	pop    %ebx
80106866:	5e                   	pop    %esi
80106867:	5f                   	pop    %edi
80106868:	5d                   	pop    %ebp
80106869:	c3                   	ret    
8010686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106870 <mappages>:
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	57                   	push   %edi
80106874:	56                   	push   %esi
80106875:	53                   	push   %ebx
80106876:	89 d3                	mov    %edx,%ebx
80106878:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010687e:	83 ec 1c             	sub    $0x1c,%esp
80106881:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106884:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106888:	8b 7d 08             	mov    0x8(%ebp),%edi
8010688b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106890:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106893:	8b 45 0c             	mov    0xc(%ebp),%eax
80106896:	29 df                	sub    %ebx,%edi
80106898:	83 c8 01             	or     $0x1,%eax
8010689b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010689e:	eb 15                	jmp    801068b5 <mappages+0x45>
801068a0:	f6 00 01             	testb  $0x1,(%eax)
801068a3:	75 45                	jne    801068ea <mappages+0x7a>
801068a5:	0b 75 dc             	or     -0x24(%ebp),%esi
801068a8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
801068ab:	89 30                	mov    %esi,(%eax)
801068ad:	74 31                	je     801068e0 <mappages+0x70>
801068af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068b8:	b9 01 00 00 00       	mov    $0x1,%ecx
801068bd:	89 da                	mov    %ebx,%edx
801068bf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801068c2:	e8 29 ff ff ff       	call   801067f0 <walkpgdir>
801068c7:	85 c0                	test   %eax,%eax
801068c9:	75 d5                	jne    801068a0 <mappages+0x30>
801068cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d3:	5b                   	pop    %ebx
801068d4:	5e                   	pop    %esi
801068d5:	5f                   	pop    %edi
801068d6:	5d                   	pop    %ebp
801068d7:	c3                   	ret    
801068d8:	90                   	nop
801068d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068e3:	31 c0                	xor    %eax,%eax
801068e5:	5b                   	pop    %ebx
801068e6:	5e                   	pop    %esi
801068e7:	5f                   	pop    %edi
801068e8:	5d                   	pop    %ebp
801068e9:	c3                   	ret    
801068ea:	83 ec 0c             	sub    $0xc,%esp
801068ed:	68 ec 79 10 80       	push   $0x801079ec
801068f2:	e8 99 9a ff ff       	call   80100390 <panic>
801068f7:	89 f6                	mov    %esi,%esi
801068f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106900 <deallocuvm.part.0>:
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
80106906:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010690c:	89 c7                	mov    %eax,%edi
8010690e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106914:	83 ec 1c             	sub    $0x1c,%esp
80106917:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010691a:	39 d3                	cmp    %edx,%ebx
8010691c:	73 66                	jae    80106984 <deallocuvm.part.0+0x84>
8010691e:	89 d6                	mov    %edx,%esi
80106920:	eb 3d                	jmp    8010695f <deallocuvm.part.0+0x5f>
80106922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106928:	8b 10                	mov    (%eax),%edx
8010692a:	f6 c2 01             	test   $0x1,%dl
8010692d:	74 26                	je     80106955 <deallocuvm.part.0+0x55>
8010692f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106935:	74 58                	je     8010698f <deallocuvm.part.0+0x8f>
80106937:	83 ec 0c             	sub    $0xc,%esp
8010693a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106940:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106943:	52                   	push   %edx
80106944:	e8 c7 b9 ff ff       	call   80102310 <kfree>
80106949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010694c:	83 c4 10             	add    $0x10,%esp
8010694f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106955:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010695b:	39 f3                	cmp    %esi,%ebx
8010695d:	73 25                	jae    80106984 <deallocuvm.part.0+0x84>
8010695f:	31 c9                	xor    %ecx,%ecx
80106961:	89 da                	mov    %ebx,%edx
80106963:	89 f8                	mov    %edi,%eax
80106965:	e8 86 fe ff ff       	call   801067f0 <walkpgdir>
8010696a:	85 c0                	test   %eax,%eax
8010696c:	75 ba                	jne    80106928 <deallocuvm.part.0+0x28>
8010696e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106974:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
8010697a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106980:	39 f3                	cmp    %esi,%ebx
80106982:	72 db                	jb     8010695f <deallocuvm.part.0+0x5f>
80106984:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106987:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010698a:	5b                   	pop    %ebx
8010698b:	5e                   	pop    %esi
8010698c:	5f                   	pop    %edi
8010698d:	5d                   	pop    %ebp
8010698e:	c3                   	ret    
8010698f:	83 ec 0c             	sub    $0xc,%esp
80106992:	68 86 73 10 80       	push   $0x80107386
80106997:	e8 f4 99 ff ff       	call   80100390 <panic>
8010699c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069a0 <seginit>:
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	83 ec 18             	sub    $0x18,%esp
801069a6:	e8 85 ce ff ff       	call   80103830 <cpuid>
801069ab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801069b1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801069b6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
801069ba:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
801069c1:	ff 00 00 
801069c4:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
801069cb:	9a cf 00 
801069ce:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801069d5:	ff 00 00 
801069d8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
801069df:	92 cf 00 
801069e2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801069e9:	ff 00 00 
801069ec:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801069f3:	fa cf 00 
801069f6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801069fd:	ff 00 00 
80106a00:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106a07:	f2 cf 00 
80106a0a:	05 f0 27 11 80       	add    $0x801127f0,%eax
80106a0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80106a13:	c1 e8 10             	shr    $0x10,%eax
80106a16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80106a1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a1d:	0f 01 10             	lgdtl  (%eax)
80106a20:	c9                   	leave  
80106a21:	c3                   	ret    
80106a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a30 <switchkvm>:
80106a30:	a1 a4 58 11 80       	mov    0x801158a4,%eax
80106a35:	55                   	push   %ebp
80106a36:	89 e5                	mov    %esp,%ebp
80106a38:	05 00 00 00 80       	add    $0x80000000,%eax
80106a3d:	0f 22 d8             	mov    %eax,%cr3
80106a40:	5d                   	pop    %ebp
80106a41:	c3                   	ret    
80106a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a50 <switchuvm>:
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	83 ec 1c             	sub    $0x1c,%esp
80106a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106a5c:	85 db                	test   %ebx,%ebx
80106a5e:	0f 84 cb 00 00 00    	je     80106b2f <switchuvm+0xdf>
80106a64:	8b 43 08             	mov    0x8(%ebx),%eax
80106a67:	85 c0                	test   %eax,%eax
80106a69:	0f 84 da 00 00 00    	je     80106b49 <switchuvm+0xf9>
80106a6f:	8b 43 04             	mov    0x4(%ebx),%eax
80106a72:	85 c0                	test   %eax,%eax
80106a74:	0f 84 c2 00 00 00    	je     80106b3c <switchuvm+0xec>
80106a7a:	e8 e1 d9 ff ff       	call   80104460 <pushcli>
80106a7f:	e8 2c cd ff ff       	call   801037b0 <mycpu>
80106a84:	89 c6                	mov    %eax,%esi
80106a86:	e8 25 cd ff ff       	call   801037b0 <mycpu>
80106a8b:	89 c7                	mov    %eax,%edi
80106a8d:	e8 1e cd ff ff       	call   801037b0 <mycpu>
80106a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a95:	83 c7 08             	add    $0x8,%edi
80106a98:	e8 13 cd ff ff       	call   801037b0 <mycpu>
80106a9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106aa0:	83 c0 08             	add    $0x8,%eax
80106aa3:	ba 67 00 00 00       	mov    $0x67,%edx
80106aa8:	c1 e8 18             	shr    $0x18,%eax
80106aab:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106ab2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106ab9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
80106abf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80106ac4:	83 c1 08             	add    $0x8,%ecx
80106ac7:	c1 e9 10             	shr    $0x10,%ecx
80106aca:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106ad0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ad5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
80106adc:	be 10 00 00 00       	mov    $0x10,%esi
80106ae1:	e8 ca cc ff ff       	call   801037b0 <mycpu>
80106ae6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
80106aed:	e8 be cc ff ff       	call   801037b0 <mycpu>
80106af2:	66 89 70 10          	mov    %si,0x10(%eax)
80106af6:	8b 73 08             	mov    0x8(%ebx),%esi
80106af9:	e8 b2 cc ff ff       	call   801037b0 <mycpu>
80106afe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106b04:	89 70 0c             	mov    %esi,0xc(%eax)
80106b07:	e8 a4 cc ff ff       	call   801037b0 <mycpu>
80106b0c:	66 89 78 6e          	mov    %di,0x6e(%eax)
80106b10:	b8 28 00 00 00       	mov    $0x28,%eax
80106b15:	0f 00 d8             	ltr    %ax
80106b18:	8b 43 04             	mov    0x4(%ebx),%eax
80106b1b:	05 00 00 00 80       	add    $0x80000000,%eax
80106b20:	0f 22 d8             	mov    %eax,%cr3
80106b23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b26:	5b                   	pop    %ebx
80106b27:	5e                   	pop    %esi
80106b28:	5f                   	pop    %edi
80106b29:	5d                   	pop    %ebp
80106b2a:	e9 71 d9 ff ff       	jmp    801044a0 <popcli>
80106b2f:	83 ec 0c             	sub    $0xc,%esp
80106b32:	68 f2 79 10 80       	push   $0x801079f2
80106b37:	e8 54 98 ff ff       	call   80100390 <panic>
80106b3c:	83 ec 0c             	sub    $0xc,%esp
80106b3f:	68 1d 7a 10 80       	push   $0x80107a1d
80106b44:	e8 47 98 ff ff       	call   80100390 <panic>
80106b49:	83 ec 0c             	sub    $0xc,%esp
80106b4c:	68 08 7a 10 80       	push   $0x80107a08
80106b51:	e8 3a 98 ff ff       	call   80100390 <panic>
80106b56:	8d 76 00             	lea    0x0(%esi),%esi
80106b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b60 <inituvm>:
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
80106b66:	83 ec 1c             	sub    $0x1c,%esp
80106b69:	8b 75 10             	mov    0x10(%ebp),%esi
80106b6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106b72:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b7b:	77 49                	ja     80106bc6 <inituvm+0x66>
80106b7d:	e8 3e b9 ff ff       	call   801024c0 <kalloc>
80106b82:	83 ec 04             	sub    $0x4,%esp
80106b85:	89 c3                	mov    %eax,%ebx
80106b87:	68 00 10 00 00       	push   $0x1000
80106b8c:	6a 00                	push   $0x0
80106b8e:	50                   	push   %eax
80106b8f:	e8 ac da ff ff       	call   80104640 <memset>
80106b94:	58                   	pop    %eax
80106b95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b9b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ba0:	5a                   	pop    %edx
80106ba1:	6a 06                	push   $0x6
80106ba3:	50                   	push   %eax
80106ba4:	31 d2                	xor    %edx,%edx
80106ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ba9:	e8 c2 fc ff ff       	call   80106870 <mappages>
80106bae:	89 75 10             	mov    %esi,0x10(%ebp)
80106bb1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106bb4:	83 c4 10             	add    $0x10,%esp
80106bb7:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106bba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bbd:	5b                   	pop    %ebx
80106bbe:	5e                   	pop    %esi
80106bbf:	5f                   	pop    %edi
80106bc0:	5d                   	pop    %ebp
80106bc1:	e9 2a db ff ff       	jmp    801046f0 <memmove>
80106bc6:	83 ec 0c             	sub    $0xc,%esp
80106bc9:	68 31 7a 10 80       	push   $0x80107a31
80106bce:	e8 bd 97 ff ff       	call   80100390 <panic>
80106bd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106be0 <loaduvm>:
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
80106be6:	83 ec 0c             	sub    $0xc,%esp
80106be9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106bf0:	0f 85 91 00 00 00    	jne    80106c87 <loaduvm+0xa7>
80106bf6:	8b 75 18             	mov    0x18(%ebp),%esi
80106bf9:	31 db                	xor    %ebx,%ebx
80106bfb:	85 f6                	test   %esi,%esi
80106bfd:	75 1a                	jne    80106c19 <loaduvm+0x39>
80106bff:	eb 6f                	jmp    80106c70 <loaduvm+0x90>
80106c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c08:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c0e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106c14:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106c17:	76 57                	jbe    80106c70 <loaduvm+0x90>
80106c19:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c1f:	31 c9                	xor    %ecx,%ecx
80106c21:	01 da                	add    %ebx,%edx
80106c23:	e8 c8 fb ff ff       	call   801067f0 <walkpgdir>
80106c28:	85 c0                	test   %eax,%eax
80106c2a:	74 4e                	je     80106c7a <loaduvm+0x9a>
80106c2c:	8b 00                	mov    (%eax),%eax
80106c2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106c31:	bf 00 10 00 00       	mov    $0x1000,%edi
80106c36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c3b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c41:	0f 46 fe             	cmovbe %esi,%edi
80106c44:	01 d9                	add    %ebx,%ecx
80106c46:	05 00 00 00 80       	add    $0x80000000,%eax
80106c4b:	57                   	push   %edi
80106c4c:	51                   	push   %ecx
80106c4d:	50                   	push   %eax
80106c4e:	ff 75 10             	pushl  0x10(%ebp)
80106c51:	e8 0a ad ff ff       	call   80101960 <readi>
80106c56:	83 c4 10             	add    $0x10,%esp
80106c59:	39 f8                	cmp    %edi,%eax
80106c5b:	74 ab                	je     80106c08 <loaduvm+0x28>
80106c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c65:	5b                   	pop    %ebx
80106c66:	5e                   	pop    %esi
80106c67:	5f                   	pop    %edi
80106c68:	5d                   	pop    %ebp
80106c69:	c3                   	ret    
80106c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c73:	31 c0                	xor    %eax,%eax
80106c75:	5b                   	pop    %ebx
80106c76:	5e                   	pop    %esi
80106c77:	5f                   	pop    %edi
80106c78:	5d                   	pop    %ebp
80106c79:	c3                   	ret    
80106c7a:	83 ec 0c             	sub    $0xc,%esp
80106c7d:	68 4b 7a 10 80       	push   $0x80107a4b
80106c82:	e8 09 97 ff ff       	call   80100390 <panic>
80106c87:	83 ec 0c             	sub    $0xc,%esp
80106c8a:	68 ec 7a 10 80       	push   $0x80107aec
80106c8f:	e8 fc 96 ff ff       	call   80100390 <panic>
80106c94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ca0 <allocuvm>:
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 1c             	sub    $0x1c,%esp
80106ca9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106cac:	85 ff                	test   %edi,%edi
80106cae:	0f 88 8e 00 00 00    	js     80106d42 <allocuvm+0xa2>
80106cb4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cb7:	0f 82 93 00 00 00    	jb     80106d50 <allocuvm+0xb0>
80106cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cc0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106cc6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106ccc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106ccf:	0f 86 7e 00 00 00    	jbe    80106d53 <allocuvm+0xb3>
80106cd5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106cd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106cdb:	eb 42                	jmp    80106d1f <allocuvm+0x7f>
80106cdd:	8d 76 00             	lea    0x0(%esi),%esi
80106ce0:	83 ec 04             	sub    $0x4,%esp
80106ce3:	68 00 10 00 00       	push   $0x1000
80106ce8:	6a 00                	push   $0x0
80106cea:	50                   	push   %eax
80106ceb:	e8 50 d9 ff ff       	call   80104640 <memset>
80106cf0:	58                   	pop    %eax
80106cf1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106cf7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106cfc:	5a                   	pop    %edx
80106cfd:	6a 06                	push   $0x6
80106cff:	50                   	push   %eax
80106d00:	89 da                	mov    %ebx,%edx
80106d02:	89 f8                	mov    %edi,%eax
80106d04:	e8 67 fb ff ff       	call   80106870 <mappages>
80106d09:	83 c4 10             	add    $0x10,%esp
80106d0c:	85 c0                	test   %eax,%eax
80106d0e:	78 50                	js     80106d60 <allocuvm+0xc0>
80106d10:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d16:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106d19:	0f 86 81 00 00 00    	jbe    80106da0 <allocuvm+0x100>
80106d1f:	e8 9c b7 ff ff       	call   801024c0 <kalloc>
80106d24:	85 c0                	test   %eax,%eax
80106d26:	89 c6                	mov    %eax,%esi
80106d28:	75 b6                	jne    80106ce0 <allocuvm+0x40>
80106d2a:	83 ec 0c             	sub    $0xc,%esp
80106d2d:	68 69 7a 10 80       	push   $0x80107a69
80106d32:	e8 29 99 ff ff       	call   80100660 <cprintf>
80106d37:	83 c4 10             	add    $0x10,%esp
80106d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d3d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d40:	77 6e                	ja     80106db0 <allocuvm+0x110>
80106d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d45:	31 ff                	xor    %edi,%edi
80106d47:	89 f8                	mov    %edi,%eax
80106d49:	5b                   	pop    %ebx
80106d4a:	5e                   	pop    %esi
80106d4b:	5f                   	pop    %edi
80106d4c:	5d                   	pop    %ebp
80106d4d:	c3                   	ret    
80106d4e:	66 90                	xchg   %ax,%ax
80106d50:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d56:	89 f8                	mov    %edi,%eax
80106d58:	5b                   	pop    %ebx
80106d59:	5e                   	pop    %esi
80106d5a:	5f                   	pop    %edi
80106d5b:	5d                   	pop    %ebp
80106d5c:	c3                   	ret    
80106d5d:	8d 76 00             	lea    0x0(%esi),%esi
80106d60:	83 ec 0c             	sub    $0xc,%esp
80106d63:	68 81 7a 10 80       	push   $0x80107a81
80106d68:	e8 f3 98 ff ff       	call   80100660 <cprintf>
80106d6d:	83 c4 10             	add    $0x10,%esp
80106d70:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d73:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d76:	76 0d                	jbe    80106d85 <allocuvm+0xe5>
80106d78:	89 c1                	mov    %eax,%ecx
80106d7a:	8b 55 10             	mov    0x10(%ebp),%edx
80106d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80106d80:	e8 7b fb ff ff       	call   80106900 <deallocuvm.part.0>
80106d85:	83 ec 0c             	sub    $0xc,%esp
80106d88:	31 ff                	xor    %edi,%edi
80106d8a:	56                   	push   %esi
80106d8b:	e8 80 b5 ff ff       	call   80102310 <kfree>
80106d90:	83 c4 10             	add    $0x10,%esp
80106d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d96:	89 f8                	mov    %edi,%eax
80106d98:	5b                   	pop    %ebx
80106d99:	5e                   	pop    %esi
80106d9a:	5f                   	pop    %edi
80106d9b:	5d                   	pop    %ebp
80106d9c:	c3                   	ret    
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi
80106da0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da6:	5b                   	pop    %ebx
80106da7:	89 f8                	mov    %edi,%eax
80106da9:	5e                   	pop    %esi
80106daa:	5f                   	pop    %edi
80106dab:	5d                   	pop    %ebp
80106dac:	c3                   	ret    
80106dad:	8d 76 00             	lea    0x0(%esi),%esi
80106db0:	89 c1                	mov    %eax,%ecx
80106db2:	8b 55 10             	mov    0x10(%ebp),%edx
80106db5:	8b 45 08             	mov    0x8(%ebp),%eax
80106db8:	31 ff                	xor    %edi,%edi
80106dba:	e8 41 fb ff ff       	call   80106900 <deallocuvm.part.0>
80106dbf:	eb 92                	jmp    80106d53 <allocuvm+0xb3>
80106dc1:	eb 0d                	jmp    80106dd0 <deallocuvm>
80106dc3:	90                   	nop
80106dc4:	90                   	nop
80106dc5:	90                   	nop
80106dc6:	90                   	nop
80106dc7:	90                   	nop
80106dc8:	90                   	nop
80106dc9:	90                   	nop
80106dca:	90                   	nop
80106dcb:	90                   	nop
80106dcc:	90                   	nop
80106dcd:	90                   	nop
80106dce:	90                   	nop
80106dcf:	90                   	nop

80106dd0 <deallocuvm>:
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106dd9:	8b 45 08             	mov    0x8(%ebp),%eax
80106ddc:	39 d1                	cmp    %edx,%ecx
80106dde:	73 10                	jae    80106df0 <deallocuvm+0x20>
80106de0:	5d                   	pop    %ebp
80106de1:	e9 1a fb ff ff       	jmp    80106900 <deallocuvm.part.0>
80106de6:	8d 76 00             	lea    0x0(%esi),%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106df0:	89 d0                	mov    %edx,%eax
80106df2:	5d                   	pop    %ebp
80106df3:	c3                   	ret    
80106df4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e00 <freevm>:
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
80106e06:	83 ec 0c             	sub    $0xc,%esp
80106e09:	8b 75 08             	mov    0x8(%ebp),%esi
80106e0c:	85 f6                	test   %esi,%esi
80106e0e:	74 59                	je     80106e69 <freevm+0x69>
80106e10:	31 c9                	xor    %ecx,%ecx
80106e12:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e17:	89 f0                	mov    %esi,%eax
80106e19:	e8 e2 fa ff ff       	call   80106900 <deallocuvm.part.0>
80106e1e:	89 f3                	mov    %esi,%ebx
80106e20:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e26:	eb 0f                	jmp    80106e37 <freevm+0x37>
80106e28:	90                   	nop
80106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e30:	83 c3 04             	add    $0x4,%ebx
80106e33:	39 fb                	cmp    %edi,%ebx
80106e35:	74 23                	je     80106e5a <freevm+0x5a>
80106e37:	8b 03                	mov    (%ebx),%eax
80106e39:	a8 01                	test   $0x1,%al
80106e3b:	74 f3                	je     80106e30 <freevm+0x30>
80106e3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e42:	83 ec 0c             	sub    $0xc,%esp
80106e45:	83 c3 04             	add    $0x4,%ebx
80106e48:	05 00 00 00 80       	add    $0x80000000,%eax
80106e4d:	50                   	push   %eax
80106e4e:	e8 bd b4 ff ff       	call   80102310 <kfree>
80106e53:	83 c4 10             	add    $0x10,%esp
80106e56:	39 fb                	cmp    %edi,%ebx
80106e58:	75 dd                	jne    80106e37 <freevm+0x37>
80106e5a:	89 75 08             	mov    %esi,0x8(%ebp)
80106e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e60:	5b                   	pop    %ebx
80106e61:	5e                   	pop    %esi
80106e62:	5f                   	pop    %edi
80106e63:	5d                   	pop    %ebp
80106e64:	e9 a7 b4 ff ff       	jmp    80102310 <kfree>
80106e69:	83 ec 0c             	sub    $0xc,%esp
80106e6c:	68 9d 7a 10 80       	push   $0x80107a9d
80106e71:	e8 1a 95 ff ff       	call   80100390 <panic>
80106e76:	8d 76 00             	lea    0x0(%esi),%esi
80106e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e80 <setupkvm>:
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	56                   	push   %esi
80106e84:	53                   	push   %ebx
80106e85:	e8 36 b6 ff ff       	call   801024c0 <kalloc>
80106e8a:	85 c0                	test   %eax,%eax
80106e8c:	89 c6                	mov    %eax,%esi
80106e8e:	74 42                	je     80106ed2 <setupkvm+0x52>
80106e90:	83 ec 04             	sub    $0x4,%esp
80106e93:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106e98:	68 00 10 00 00       	push   $0x1000
80106e9d:	6a 00                	push   $0x0
80106e9f:	50                   	push   %eax
80106ea0:	e8 9b d7 ff ff       	call   80104640 <memset>
80106ea5:	83 c4 10             	add    $0x10,%esp
80106ea8:	8b 43 04             	mov    0x4(%ebx),%eax
80106eab:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106eae:	83 ec 08             	sub    $0x8,%esp
80106eb1:	8b 13                	mov    (%ebx),%edx
80106eb3:	ff 73 0c             	pushl  0xc(%ebx)
80106eb6:	50                   	push   %eax
80106eb7:	29 c1                	sub    %eax,%ecx
80106eb9:	89 f0                	mov    %esi,%eax
80106ebb:	e8 b0 f9 ff ff       	call   80106870 <mappages>
80106ec0:	83 c4 10             	add    $0x10,%esp
80106ec3:	85 c0                	test   %eax,%eax
80106ec5:	78 19                	js     80106ee0 <setupkvm+0x60>
80106ec7:	83 c3 10             	add    $0x10,%ebx
80106eca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ed0:	75 d6                	jne    80106ea8 <setupkvm+0x28>
80106ed2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ed5:	89 f0                	mov    %esi,%eax
80106ed7:	5b                   	pop    %ebx
80106ed8:	5e                   	pop    %esi
80106ed9:	5d                   	pop    %ebp
80106eda:	c3                   	ret    
80106edb:	90                   	nop
80106edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ee0:	83 ec 0c             	sub    $0xc,%esp
80106ee3:	56                   	push   %esi
80106ee4:	31 f6                	xor    %esi,%esi
80106ee6:	e8 15 ff ff ff       	call   80106e00 <freevm>
80106eeb:	83 c4 10             	add    $0x10,%esp
80106eee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ef1:	89 f0                	mov    %esi,%eax
80106ef3:	5b                   	pop    %ebx
80106ef4:	5e                   	pop    %esi
80106ef5:	5d                   	pop    %ebp
80106ef6:	c3                   	ret    
80106ef7:	89 f6                	mov    %esi,%esi
80106ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f00 <kvmalloc>:
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	83 ec 08             	sub    $0x8,%esp
80106f06:	e8 75 ff ff ff       	call   80106e80 <setupkvm>
80106f0b:	a3 a4 58 11 80       	mov    %eax,0x801158a4
80106f10:	05 00 00 00 80       	add    $0x80000000,%eax
80106f15:	0f 22 d8             	mov    %eax,%cr3
80106f18:	c9                   	leave  
80106f19:	c3                   	ret    
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f20 <clearpteu>:
80106f20:	55                   	push   %ebp
80106f21:	31 c9                	xor    %ecx,%ecx
80106f23:	89 e5                	mov    %esp,%ebp
80106f25:	83 ec 08             	sub    $0x8,%esp
80106f28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2e:	e8 bd f8 ff ff       	call   801067f0 <walkpgdir>
80106f33:	85 c0                	test   %eax,%eax
80106f35:	74 05                	je     80106f3c <clearpteu+0x1c>
80106f37:	83 20 fb             	andl   $0xfffffffb,(%eax)
80106f3a:	c9                   	leave  
80106f3b:	c3                   	ret    
80106f3c:	83 ec 0c             	sub    $0xc,%esp
80106f3f:	68 ae 7a 10 80       	push   $0x80107aae
80106f44:	e8 47 94 ff ff       	call   80100390 <panic>
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f50 <copyuvm>:
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
80106f56:	83 ec 1c             	sub    $0x1c,%esp
80106f59:	e8 22 ff ff ff       	call   80106e80 <setupkvm>
80106f5e:	85 c0                	test   %eax,%eax
80106f60:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f63:	0f 84 9f 00 00 00    	je     80107008 <copyuvm+0xb8>
80106f69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f6c:	85 c9                	test   %ecx,%ecx
80106f6e:	0f 84 94 00 00 00    	je     80107008 <copyuvm+0xb8>
80106f74:	31 ff                	xor    %edi,%edi
80106f76:	eb 4a                	jmp    80106fc2 <copyuvm+0x72>
80106f78:	90                   	nop
80106f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f80:	83 ec 04             	sub    $0x4,%esp
80106f83:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106f89:	68 00 10 00 00       	push   $0x1000
80106f8e:	53                   	push   %ebx
80106f8f:	50                   	push   %eax
80106f90:	e8 5b d7 ff ff       	call   801046f0 <memmove>
80106f95:	58                   	pop    %eax
80106f96:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f9c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fa1:	5a                   	pop    %edx
80106fa2:	ff 75 e4             	pushl  -0x1c(%ebp)
80106fa5:	50                   	push   %eax
80106fa6:	89 fa                	mov    %edi,%edx
80106fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fab:	e8 c0 f8 ff ff       	call   80106870 <mappages>
80106fb0:	83 c4 10             	add    $0x10,%esp
80106fb3:	85 c0                	test   %eax,%eax
80106fb5:	78 61                	js     80107018 <copyuvm+0xc8>
80106fb7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106fbd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106fc0:	76 46                	jbe    80107008 <copyuvm+0xb8>
80106fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc5:	31 c9                	xor    %ecx,%ecx
80106fc7:	89 fa                	mov    %edi,%edx
80106fc9:	e8 22 f8 ff ff       	call   801067f0 <walkpgdir>
80106fce:	85 c0                	test   %eax,%eax
80106fd0:	74 61                	je     80107033 <copyuvm+0xe3>
80106fd2:	8b 00                	mov    (%eax),%eax
80106fd4:	a8 01                	test   $0x1,%al
80106fd6:	74 4e                	je     80107026 <copyuvm+0xd6>
80106fd8:	89 c3                	mov    %eax,%ebx
80106fda:	25 ff 0f 00 00       	and    $0xfff,%eax
80106fdf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106fe5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fe8:	e8 d3 b4 ff ff       	call   801024c0 <kalloc>
80106fed:	85 c0                	test   %eax,%eax
80106fef:	89 c6                	mov    %eax,%esi
80106ff1:	75 8d                	jne    80106f80 <copyuvm+0x30>
80106ff3:	83 ec 0c             	sub    $0xc,%esp
80106ff6:	ff 75 e0             	pushl  -0x20(%ebp)
80106ff9:	e8 02 fe ff ff       	call   80106e00 <freevm>
80106ffe:	83 c4 10             	add    $0x10,%esp
80107001:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107008:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010700b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010700e:	5b                   	pop    %ebx
8010700f:	5e                   	pop    %esi
80107010:	5f                   	pop    %edi
80107011:	5d                   	pop    %ebp
80107012:	c3                   	ret    
80107013:	90                   	nop
80107014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107018:	83 ec 0c             	sub    $0xc,%esp
8010701b:	56                   	push   %esi
8010701c:	e8 ef b2 ff ff       	call   80102310 <kfree>
80107021:	83 c4 10             	add    $0x10,%esp
80107024:	eb cd                	jmp    80106ff3 <copyuvm+0xa3>
80107026:	83 ec 0c             	sub    $0xc,%esp
80107029:	68 d2 7a 10 80       	push   $0x80107ad2
8010702e:	e8 5d 93 ff ff       	call   80100390 <panic>
80107033:	83 ec 0c             	sub    $0xc,%esp
80107036:	68 b8 7a 10 80       	push   $0x80107ab8
8010703b:	e8 50 93 ff ff       	call   80100390 <panic>

80107040 <uva2ka>:
80107040:	55                   	push   %ebp
80107041:	31 c9                	xor    %ecx,%ecx
80107043:	89 e5                	mov    %esp,%ebp
80107045:	83 ec 08             	sub    $0x8,%esp
80107048:	8b 55 0c             	mov    0xc(%ebp),%edx
8010704b:	8b 45 08             	mov    0x8(%ebp),%eax
8010704e:	e8 9d f7 ff ff       	call   801067f0 <walkpgdir>
80107053:	8b 00                	mov    (%eax),%eax
80107055:	c9                   	leave  
80107056:	89 c2                	mov    %eax,%edx
80107058:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010705d:	83 e2 05             	and    $0x5,%edx
80107060:	05 00 00 00 80       	add    $0x80000000,%eax
80107065:	83 fa 05             	cmp    $0x5,%edx
80107068:	ba 00 00 00 00       	mov    $0x0,%edx
8010706d:	0f 45 c2             	cmovne %edx,%eax
80107070:	c3                   	ret    
80107071:	eb 0d                	jmp    80107080 <copyout>
80107073:	90                   	nop
80107074:	90                   	nop
80107075:	90                   	nop
80107076:	90                   	nop
80107077:	90                   	nop
80107078:	90                   	nop
80107079:	90                   	nop
8010707a:	90                   	nop
8010707b:	90                   	nop
8010707c:	90                   	nop
8010707d:	90                   	nop
8010707e:	90                   	nop
8010707f:	90                   	nop

80107080 <copyout>:
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 1c             	sub    $0x1c,%esp
80107089:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010708c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010708f:	8b 7d 10             	mov    0x10(%ebp),%edi
80107092:	85 db                	test   %ebx,%ebx
80107094:	75 40                	jne    801070d6 <copyout+0x56>
80107096:	eb 70                	jmp    80107108 <copyout+0x88>
80107098:	90                   	nop
80107099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070a3:	89 f1                	mov    %esi,%ecx
801070a5:	29 d1                	sub    %edx,%ecx
801070a7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801070ad:	39 d9                	cmp    %ebx,%ecx
801070af:	0f 47 cb             	cmova  %ebx,%ecx
801070b2:	29 f2                	sub    %esi,%edx
801070b4:	83 ec 04             	sub    $0x4,%esp
801070b7:	01 d0                	add    %edx,%eax
801070b9:	51                   	push   %ecx
801070ba:	57                   	push   %edi
801070bb:	50                   	push   %eax
801070bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801070bf:	e8 2c d6 ff ff       	call   801046f0 <memmove>
801070c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070c7:	83 c4 10             	add    $0x10,%esp
801070ca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
801070d0:	01 cf                	add    %ecx,%edi
801070d2:	29 cb                	sub    %ecx,%ebx
801070d4:	74 32                	je     80107108 <copyout+0x88>
801070d6:	89 d6                	mov    %edx,%esi
801070d8:	83 ec 08             	sub    $0x8,%esp
801070db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801070de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801070e4:	56                   	push   %esi
801070e5:	ff 75 08             	pushl  0x8(%ebp)
801070e8:	e8 53 ff ff ff       	call   80107040 <uva2ka>
801070ed:	83 c4 10             	add    $0x10,%esp
801070f0:	85 c0                	test   %eax,%eax
801070f2:	75 ac                	jne    801070a0 <copyout+0x20>
801070f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070fc:	5b                   	pop    %ebx
801070fd:	5e                   	pop    %esi
801070fe:	5f                   	pop    %edi
801070ff:	5d                   	pop    %ebp
80107100:	c3                   	ret    
80107101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107108:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010710b:	31 c0                	xor    %eax,%eax
8010710d:	5b                   	pop    %ebx
8010710e:	5e                   	pop    %esi
8010710f:	5f                   	pop    %edi
80107110:	5d                   	pop    %ebp
80107111:	c3                   	ret    
