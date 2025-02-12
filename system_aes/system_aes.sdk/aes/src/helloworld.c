/******************************************************************************
 *
 * Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Use of the Software is limited solely to applications:
 * (a) running on a Xilinx device, or
 * (b) that interact with a Xilinx device through a bus or interconnect.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Except as contained in this notice, the name of the Xilinx shall not be used
 * in advertising or otherwise to promote the sale, use or other dealings in
 * this Software without prior written authorization from Xilinx.
 *
 ******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include "address.h"
#include "xbram_hw.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xscutimer.h"
#include <stdio.h>

#define TIMER_LOAD_VALUE 0x10000000
#define TIMER_DEVICE_ID XPAR_XSCUTIMER_0_DEVICE_ID

// assert FPGA Reset Signal
#define XSLCR_BASEADDR 0xF8000000U
#define XSLCR_LOCK_ADDR (XSLCR_BASEADDR + 0x00000004U)
#define XSLCR_UNLOCK_ADDR (XSLCR_BASEADDR + 0x00000008U)
#define XSLCR_FPGA_RST_CTRL_ADDR (XSLCR_BASEADDR + 0x00000240U)

/**< SLCR unlock code */
#define XSLCR_LOCK_CODE 0x0000767BU
#define XSLCR_UNLOCK_CODE 0x0000DF0DU

#define ENTROPT_NUM 3

XScuTimer TimerInstance; /* Cortex A9 Scu Private Timer Instance */
XScuTimer Timer;         /* Cortex A9 SCU Private Timer Instance */
XScuTimer *TimerInstancePtr = &Timer;

void timer_init(XScuTimer *TimerInstancePtr, u16 TimerDeviceId)
{
    XScuTimer_Config *ConfigPtr;
    // ��ʼ��˽�ж�ʱ��
    ConfigPtr = XScuTimer_LookupConfig(TimerDeviceId);
    XScuTimer_CfgInitialize(TimerInstancePtr, ConfigPtr,
                            ConfigPtr->BaseAddr);
    // ʹ���Զ�װ��
    XScuTimer_EnableAutoReload(TimerInstancePtr);
    // ���üĴ���
    XScuTimer_LoadTimer(TimerInstancePtr, TIMER_LOAD_VALUE);
}

int main(void)
{

    //	 Xil_Out32(XSLCR_UNLOCK_ADDR, XSLCR_UNLOCK_CODE);
    //     Xil_Out32(XSLCR_FPGA_RST_CTRL_ADDR, 0x0F);
    //
    //     // do stuff
    //
    //     // and release the FPGA Reset Signal
    //     Xil_Out32(XSLCR_FPGA_RST_CTRL_ADDR, 0x00);
    //     Xil_Out32(XSLCR_LOCK_ADDR, XSLCR_LOCK_CODE);

    // �ر�PL��λ
    Xil_Out32(0xF8000008, 0xDF0D); // 57101==0xDF0D �رո�λд����
    Xil_Out32(0xF8000240, 0);      // FCLK_RESET0_N=1
    Xil_Out32(0xF8000008, 0x767B); // ���¿�����λд����

    // ����PL��λ
    Xil_Out32(0xF8000008, 0xDF0D); // 57101==0xDF0D �رո�λд����
    Xil_Out32(0xF8000240, 1);      // FCLK_RESET0_N=0
    Xil_Out32(0xF8000008, 0x767B); // ���¿�����λд����

    // �ر�PL��λ
    Xil_Out32(0xF8000008, 0xDF0D); // 57101==0xDF0D �رո�λд����
    Xil_Out32(0xF8000240, 0);      // FCLK_RESET0_N=1
    Xil_Out32(0xF8000008, 0x767B); // ���¿�����λд����

    volatile u32 CntValue0 = 0; // begin
    volatile u32 CntValue1 = 0; // ���üĴ�����ɣ����ܿ�ʼ
    volatile u32 CntValue2 = 0; // ���ܽ���

    // ��ʼ��
    int i;
    i = 0;
    timer_init(&Timer, TIMER_DEVICE_ID);

    for (i = 0; i < 99; i++) {
        *(unsigned int *)(ENTRYPT_BASE + 4 * i) = 0;
        *(unsigned int *)(MINGWEN_BASE + 4 * i) = 0;
    }

    CntValue0 = XScuTimer_GetCounterValue(&Timer);
    XScuTimer_Start(&Timer);
    //        for ( i = 0; i < 99; i++)
    //    {
    //        *(unsigned int*) (MINGWEN_BASE+0)    = 0xd7e5dbd3 ;
    //        *(unsigned int*) (MINGWEN_BASE+4)    = 0x324595f8 ;
    //        *(unsigned int*) (MINGWEN_BASE+8)    = 0xfdc7d7c5 ;
    //        *(unsigned int*) (MINGWEN_BASE+12)   = 0x71da6c2a ;

    //    }

    // һ����д��n��128λ����������
    for (i = 0; i < ENTROPT_NUM; i++) {
        *(unsigned int *)(MINGWEN_BASE + 16 * i + 0) = 0x12345678 + i;
        *(unsigned int *)(MINGWEN_BASE + 16 * i + 4) = 0x9abcdef0 + i;
        *(unsigned int *)(MINGWEN_BASE + 16 * i + 8) = 0x0fedcba9 + i;
        *(unsigned int *)(MINGWEN_BASE + 16 * i + 12) = 0x87654321 + i;
    }

    printf("\nbegin\n");
    *(unsigned int *)(AES_BASE + 0x18) = 0;            // STATE
    *(unsigned int *)(AES_BASE + 0x1c) = 0;            // MODULE
    *(unsigned int *)AES_BASE = MINGWEN_BASE;          // read_addr
    *(unsigned int *)(AES_BASE + 0x04) = ENTRYPT_BASE; // write_addr

    *(unsigned int *)(AES_BASE + 0x08) = 0x01234567; // key
    *(unsigned int *)(AES_BASE + 0x0c) = 0x89abcdef; // key
    *(unsigned int *)(AES_BASE + 0x10) = 0x01234567; // key
    CntValue1 = XScuTimer_GetCounterValue(&Timer);
    *(unsigned int *)(AES_BASE + 0x14) = 0x89ABCDEF; // key

    // ��ӡ10��128λ����������
    printf("print ciphertext:\n");
    for (i = 0; i < ENTROPT_NUM; i++) {
        unsigned int ciphertext_part1 = *(unsigned int *)(ENTRYPT_BASE + 16 * i);
        unsigned int ciphertext_part2 = *(unsigned int *)(ENTRYPT_BASE + 16 * i);
        unsigned int ciphertext_part3 = *(unsigned int *)(ENTRYPT_BASE + 16 * i);
        unsigned int ciphertext_part4 = *(unsigned int *)(ENTRYPT_BASE + 16 * i);
        printf("ciphertext %d: %08x%08x%08x%08x\n", i, ciphertext_part1, ciphertext_part2, ciphertext_part3, ciphertext_part4);
    }

    printf("Encryption succeed!\n");
    while (1)
        ;
    return 0;
}
